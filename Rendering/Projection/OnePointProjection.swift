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
    
    func distanceTo3D(_ location: Vector3) -> CGFloat {
        let locViewMiddle = (toView[0] + toView[1] + toView[2] + toView[3]) / 4.0
        return (location - locViewMiddle).magnitude()
        // ToDo: add sign for location in front of view (always forward plane check) (is it dot product?)
    }
    func distanceTo3D(_ index: Int, _ location: Vector3) -> CGFloat {
        return (location - toView[index]).magnitude()        
    }
    func getWinding() -> GLWinding {
        //        print("\(toView)")
        let v0 = (toView[3] - toView[0]).normalized()
        let v1 = (toView[1] - toView[0]).normalized()
        // ToDo: normal seems incorrect for top face?!
        //        print("\(v0) \(v1)")        
        var cross = Vector3.cross(v1, v0)
        //        print("\(cross)")
        var tempA = 0.0
        if let vt = viewTarget {
            //            var angle = vt.transform.a
            tempA = vt.transform.a
            var qA = Quaternion(angle: tempA, axis: .yAxis)
            cross = qA.rot(cross)
            //            cross = vt.transform.rotation.rot(cross)
            //            let qAngle = Quaternion(angle: 0, axis: cross)
            //            tempA = radToDeg(qAngle.getAngle(vt.transform.rotation))
        }
        //        cross
        // ToDo: check & validate the transform.forward (rotated values don't seem correct)
        let fwd: Vector3 = (viewTarget?.transform.forward ?? .zAxis)
        let dot = Vector3.dot(cross, fwd)
        var rad = radToDeg(atan2(cross.magnitude(), Vector3.dot(cross, fwd)))
        
        //        let qAngle2 = Quaternion(angle: 0, axis: cross)
        //        rad = qAngle2.getAngle(viewTarget?.transform.rotation ?? .init())
        // ToDo: include check for transformed vertices all below or all above camera position
        //        print("Cross: \(toView[1]) - \(toView[0]) ==> \(v0) x \(v1) == \(cross) -> \(rad) :: \(tempA)")
        print("Cross: \(cross) \(fwd) -> \(rad) :: \(dot)")
        
        // ToDo: PRIO: Replace GLQuat, GLFloat3 and GLFloat2 with SwiftGeom types
        //        let fwdNew: Vector3 = .init(0, 1, 0)
        //        let qAngle = Quaternion(angle: 90, axis: .init(0, 0, 1))
        //        let fwdRotated = qAngle.rot(cross)
        //        print("Rot: \(fwdRotated)")
        //                print("Rot: \(fwdNew) \(fwdRotated)")
        //        print("View: \(toView[0]) \(toView[1])")
        // reverse comparison to enable correct culling
        //        return rad >= 44.5 && rad <= 90 ? .ccw : .cw
        //        return tempA < 90 || tempA > 270 ? .ccw : .cw
        return dot <= 1 ? .ccw : .cw
    }
    
    func projectToView(_ p0: Vector3, _ p1: Vector3, _ p2: Vector3, _ p3: Vector3) {
        if let vt = self.viewTarget {
            let viewTfs = vt.transform
            let viewLoc = viewTfs.location
            let fov = vt.fov
            
            var toView: [Vector3] = [p0 - viewLoc, p1 - viewLoc, p2 - viewLoc, p3 - viewLoc]
            //            let v0 = Vector3(-0.125, 0.90625,0.125) - Vector3(-0.125, 0.65625,0.125)
            //            let v1 = Vector3(0.125, 0.90625,0.125) - Vector3.init(-0.125, 0.65625,0.125)
            //            let tmpCross = Vector3.cross(v1, v0)
            //            print("\(v0.normalized()) x \(v1.normalized()) = \(tmpCross)")
            for i in 0..<toView.count {
                let vC = toView[i]
                //                let vC = vt.transform.rotation.rot(toView[i])
                var newCoord = vC
                newCoord = vt.transform.rotation.rot(newCoord)
//                swap(&newCoord.y, &newCoord.z)
                // ToDo: rework to exclude fov in ToView projection but in ToScreen (as it should be?!)
                //        hopefully the normals are more understandable within normal 
                // ToDo: redo toView/ToScreen to have view space align with x,y,z axes (right, front, up) 
                //        (atm it is x,y,z (right, up, front)
                // ToDo: may consider including spanning the 'near-far' clip range
                
                //                newCoord.x = (vC.x * cosine - vC.y * sine) / resolution
                //                newCoord.y = (vC.y * cosine + vC.x * sine) / vt.fov
                //                if vC.z >= 0 {
                //                    newCoord.z = (vC.z + (newCoord.y)) / resolution
                //                } else {
                //                    newCoord.z = (vC.z - (newCoord.y)) / resolution
                //                }
                //                newCoord.x = (vC.x * cosine - vC.y * sine)
                //                newCoord.y = (vC.y * cosine + vC.x * sine) 
                //                                if vC.z >= 0 {
                //                newCoord.z = (vC.z) + newCoord.y / 10
                //                                } else {
                //                                    newCoord.z = (-vC.z)
                //                                }
                //                swap(&newCoord.y, &newCoord.z)
                toView[i] = newCoord // / resolution
            }
            //            
            //            if allSubZero {
            //                for i in 0..<toView.count {
            //                    toView[i].z = toView[i].z - (toView[i].y / resolution)
            //                }
            //            }
            //            print("View: \(toView)")
            
            self.toView.removeAll()
            self.toView.append(contentsOf: toView)
        }
        
    }
    func projectToView(_ p1: Vector2, _ p2: Vector2, ze1: ZEdge, ze2: ZEdge) { }
    
    func projectToScreen() -> Bool {
        if let vt = self.viewTarget {
            var clipped: Bool = false
            let fov = vt.fov 
            
            for i in 0..<toView.count {
                toScreen[i] = .init(toView[i].x, toView[i].y)
                
                if toScreen[i].y <= 0 { toScreen[i].y = -1; clipped = true } // clip y if zero
                if toScreen[i].y != 0 { 
                    // ToDo: add fov to projectToView (I should have correct view space normals then?!
                    toScreen[i].x = (toView[i].x / (toScreen[i].y) * resolution) + vt.w2 
                    toScreen[i].y = (toView[i].z / (toScreen[i].y) * resolution) + vt.h2
                }
            }
            
            //            print("Screen: \(toScreen[0]), \(toScreen[1]), \(toScreen[2]), \(toScreen[3]))")
            return clipped
        }
        // failed projection (indicates invalid/erratic data left in projection)
        return true
    }
}
