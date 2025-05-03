import SwiftUI

// one-vanishing-point-perspective
class OnePointProjection: TransformerStage, Projection {
    // === Members ===
    // === Properties ===
    // ToDo: continue reworking winding to work with a full cube made of quads (which will be my starting point for other complex types?!
    //        Could passthrough winding from RDData (but would by kinda hacky)
    //        instead projection shouldn't affect winding and RDData should define it them selves (they should be able to tell, at least after projection/culling stages)
    var winding: GLWinding { get { return .cw } }
    
    // === Ctors ===
    init(_ newResolution: CGFloat) {
        super.init()
        self.resolution = newResolution.isZero ? 1.0 : newResolution
    }
    
    // === Functions ===    
    func cullNear() -> Bool {
        if let vt = viewTarget { return toView.compactMap { i in i.y }.less(vt.nearClip) }
        return false
    }
    func cullFar() -> Bool {
        if let vt = viewTarget { return toView.compactMap { i in i.y }.greater(vt.farClip) }
        return false
    }
    
    func clipNear() -> Bool {
        if let vt = viewTarget {
            var clipped: Bool = false
            for i in 0..<toView.count {
                if toView[i].y <= vt.nearClip { toView[i].y = vt.nearClip + 1; clipped = true }
            }
            return clipped
        }
        return false
    }
    func clipFar() -> Bool { return false }
    
    func distanceTo3D(_ location: GLFloat3) -> CGFloat {
        let locViewMiddle = (toView[0] + toView[1] + toView[2] + toView[3]) / 4.0
        return (location - locViewMiddle).magnitude
        // ToDo: add sign for location in front of view (always forward plane check) (is it dot product?)
    }
    func distanceTo3D(_ index: Int, _ location: GLFloat3) -> CGFloat {
        return (location - toView[index]).magnitude        
    }
    func getWinding() -> GLWinding {
        let v0 = (toView[2] - toView[1]).normalized()
        let v1 = (toView[0] - toView[1]).normalized()

        var cross = GLFloat3.cross(v1, v0)
        if let vt = viewTarget {
            var angle = vt.transform.a
            if angle < 270 && angle > 90 { angle -= 180 }
            // rework
            print("Angle: \(vt.transform.a) A': \(angle)")
            let rotCrossXY = cross.xy.rotate(angle, .zero)
            cross = .init(rotCrossXY.x, rotCrossXY.y, cross.z);
        }
//        cross
        // ToDo: check & validate the transform.forward (rotated values don't seem correct)
        let fwd = GLFloat3.forward // (viewTarget?.transform.forward ?? .forward)
        let dot = GLFloat3.dot(cross, fwd)
//        let rad = AngleBetweenTwoVectors(vA: cross, vB: fwd) * (180.0 / .pi)
        // ToDo: include check for transformed vertices all below or all above camera position
        //    all 
        
//        print("View: \(cross) -> \(dot)")
//        print("View: \(toView)\n\(cross) -> \(dot)")
        // reverse comparison to enable correct culling
        return dot < 1 ? .ccw : .cw
    }
    func AngleBetweenTwoVectors(vA: GLFloat3, vB: GLFloat3) -> CGFloat {
        var fCrossX:CGFloat, fCrossY:CGFloat, fCrossZ:CGFloat,
            fCross:CGFloat, fDot:CGFloat;
        fCrossX = vA.y * vB.z - vA.z * vB.y;
        fCrossY = vA.z * vB.x - vA.x * vB.z;
        fCrossZ = vA.x * vB.y - vA.y * vB.x;
        fCross = sqrt(fCrossX * fCrossX + fCrossY * fCrossY + fCrossZ * fCrossZ);
        fDot = vA.x * vB.x + vA.y * vB.y + vA.z + vB.z;
        return atan2(fCross, fDot);
    }
    
    func projectToView(_ p0: GLFloat3, _ p1: GLFloat3, _ p2: GLFloat3, _ p3: GLFloat3) {
        if let vt = self.viewTarget {
            let viewTfs = vt.transform
            let viewLoc = viewTfs.location
            
            var toView: [GLFloat3] = [p0, p1, p2, p3]
            for i in 0..<toView.count {
                let vC = toView[i] - viewLoc
                var newCoord = vC
                newCoord.x = (vC.x * cosine - vC.y * sine) / resolution
                newCoord.y = (vC.y * cosine + vC.x * sine) / vt.fov
                if vC.z > 0 {
                    newCoord.z = (vC.z + (newCoord.y)) / resolution   
                } else {
                    newCoord.z = (vC.z - (newCoord.y)) / resolution
                }
                toView[i] = newCoord
            }
            
//            print("View: \(toView)")
            
            self.toView.removeAll()
            self.toView.append(contentsOf: toView)
        }
        
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) { }
    
    func projectToScreen() -> Bool {
        if let vt = self.viewTarget {
            var clipped: Bool = false
            let fov = vt.fov 
            
            for i in 0..<toView.count {
                toScreen[i] = toView[i].xy
                
                if toScreen[i].y == 0 { toScreen[i].y = -1; clipped = true } // clip y if zero
                if toScreen[i].y != 0 { 
                    // ToDo: add fov to projectToView (I should have correct view space normals then?!
                    toScreen[i].x = (toView[i].x / toScreen[i].y * resolution) + vt.w2 
                    toScreen[i].y = (toView[i].z / toScreen[i].y * resolution) + vt.h2
                }
            }

//            print("Screen: \(toScreen[0]), \(toScreen[1]), \(toScreen[2]), \(toScreen[3]))")
            return clipped
        }
        // failed projection (indicates invalid/erratic data left in projection)
        return true
    }
}
