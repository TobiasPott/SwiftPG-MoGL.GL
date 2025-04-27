import SwiftUI

// one-vanishing-point-perspective
class OnePointProjection: TransformerStage, Projection {
    // === Members ===
    // === Properties ===
    // ToDo: continue reworking winding to work with a full cube made of quads (which will be my starting point for other complex types?!
    //        Could passthrough winding from RDData (but would by kinda hacky)
    //        instead projection shouldn't affect winding and RDData should define it them selves (they should be able to tell, at least after projection/culling stages)
    var winding: GLWinding { get { return .cw } } // (toScreen[1].x > toScreen[0].x) ? .ccw : .cw } }
    
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
        let locViewMiddle = (toView[0] + toView[1]) / 2.0
        return (location - locViewMiddle).magnitude
    }
    func projectToView(_ pb1: GLFloat3, _ pb2: GLFloat3, _ pt1: GLFloat3, _ pt2: GLFloat3) {
        
        // ToDo: transfer from projectToView(CGPoint..)
        // when implementing, try avoiding carrying over point order (assume ccw winding but not starting at bottom points (though it will help understanding)
        if let vt = self.viewTarget {
            let viewTfs = vt.transform
            let viewLoc = viewTfs.location
            
            var toView: [GLFloat3] = [pb1, pb2, pt1, pt2]
            for i in 0..<toView.count {
                let vC = toView[i] - viewLoc
                var newCoord = vC
                newCoord.x = (vC.x * cosine - vC.y * sine)
                newCoord.y = (vC.y * cosine + vC.x * sine)
                newCoord.z = (vC.z) + (newCoord.y / resolution)
                toView[i] = newCoord
            }
            /*
            //offset bottom 2 points by player
            let np1 = p1 - viewLoc 
            let np2 = p2 - viewLoc
            
            //view X position
            toView[0].x = (np1.x * cosine - np1.y * sine);
            toView[1].x = (np2.x * cosine - np2.y * sine);
            toView[2].x = (toView[1].x)
            toView[3].x = (toView[0].x)
            
            //view Y position (depth)
            toView[0].y = (np1.y * cosine + np1.x * sine)
            toView[1].y = (np2.y * cosine + np2.x * sine)
            toView[2].y = (toView[1].y) 
            toView[3].y = (toView[0].y)
            
            //view z height
            toView[3].z = (ze1.min - (viewTfs.z) + (toView[3].y / resolution)) 
            toView[2].z = (ze2.min - (viewTfs.z) + (toView[2].y / resolution))
            toView[1].z = (ze2.max - (viewTfs.z) + (toView[1].y / resolution))
            toView[0].z = (ze1.max - (viewTfs.z) + (toView[0].y / resolution))
            */
            self.toView.removeAll()
            self.toView.append(contentsOf: toView)
        }
        
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) {
        if let vt = self.viewTarget {
            let viewTfs = vt.transform
            let viewLoc = viewTfs.location
            
            //offset bottom 2 points by player
            let np1 = p1 - viewLoc.xy
            let np2 = p2 - viewLoc.xy
            
            //view X position
            var toView: [GLFloat3] = [.zero, .zero, .zero, .zero]
            toView[0].x = (np1.x * cosine - np1.y * sine);
            toView[1].x = (np2.x * cosine - np2.y * sine);
            toView[2].x = (toView[1].x)
            toView[3].x = (toView[0].x)
            
            //view Y position (depth)
            toView[0].y = (np1.y * cosine + np1.x * sine)
            toView[1].y = (np2.y * cosine + np2.x * sine)
            toView[2].y = (toView[1].y) 
            toView[3].y = (toView[0].y)
            
            //view z height
            toView[3].z = (ze1.min - (viewTfs.z) + (toView[3].y / resolution)) 
            toView[2].z = (ze2.min - (viewTfs.z) + (toView[2].y / resolution))
            toView[1].z = (ze2.max - (viewTfs.z) + (toView[1].y / resolution))
            toView[0].z = (ze1.max - (viewTfs.z) + (toView[0].y / resolution))
            
            self.toView.removeAll()
            self.toView.append(contentsOf: toView)
        }
    }
    
    func projectToScreen() -> Bool {
        if let vt = self.viewTarget {
            var clipped: Bool = false
            let fov = vt.fov 
            
            for i in 0..<toView.count {
                toScreen[i] = toView[i].xy
                if toScreen[i].y == 0 { toView[i].y = -1; clipped = true } // clip y if zero
                if toScreen[i].y != 0 { 
                    toScreen[i].x = toView[i].x * fov / toScreen[i].y + vt.w2 
                    toScreen[i].y = toView[i].z * fov / toScreen[i].y + vt.h2 
                }
            }
            return clipped
        }
        // failed projection (indicates invalid/erratic data left in projection)
        return true
    }
}
