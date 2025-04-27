import SwiftUI

// one-vanishing-point-perspective
class OnePointProjection: TransformerStage, Projection {
    // === Members ===
    // === Properties ===
    var winding: GLWinding { get { return (toScreen[1].x > toScreen[0].x) ? .ccw : .cw } }
    
    // === Ctors ===
    init(_ newResolution: CGFloat) {
        super.init()
        self.resolution = newResolution.isZero ? 1.0 : newResolution
    }
    
    // === Functions ===    
    func cullNear() -> Bool {
        if let c = camera { return toView.compactMap { i in i.y }.less(c.nearClip) }
        return false
    }
    func cullFar() -> Bool {
        if let c = camera { return toView.compactMap { i in i.y }.greater(c.farClip) }
        return false
    }
    
    func clipNear() -> Bool {
        if let c = camera {
            var clipped: Bool = false
            for i in 0..<toView.count {
                if toView[i].y <= c.nearClip { toView[i].y = c.nearClip + 1; clipped = true }
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
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) {
        if let camera = self.camera {
            let cameraTfs = camera.transform
            let cameraLoc = cameraTfs.location
            
            //offset bottom 2 points by player
            let np1 = p1 - cameraLoc 
            let x1: CGFloat = np1.x
            let y1: CGFloat = np1.y
            
            let np2 = p2 - cameraLoc
            let x2: CGFloat = np2.x
            let y2: CGFloat = np2.y
            
            //view X position
            var toView: [GLFloat3] = [.zero, .zero, .zero, .zero]
            toView[0].x = (x1 * cosine - y1 * sine);
            toView[1].x = (x2 * cosine - y2 * sine);
            toView[2].x = (toView[1].x)
            toView[3].x = (toView[0].x)
            
            //view Y position (depth)
            toView[0].y = (y1 * cosine + x1 * sine)
            toView[1].y = (y2 * cosine + x2 * sine)
            toView[2].y = (toView[1].y) 
            toView[3].y = (toView[0].y)
            
            //view z height
            toView[3].z = (ze1.min - CGFloat(cameraTfs.z) + (toView[3].y / resolution)) 
            toView[2].z = (ze2.min - CGFloat(cameraTfs.z) + (toView[2].y / resolution))
            toView[1].z = (ze2.max - CGFloat(cameraTfs.z) + (toView[1].y / resolution))
            toView[0].z = (ze1.max - CGFloat(cameraTfs.z) + (toView[0].y / resolution))
            
            self.toView.removeAll()
            self.toView.append(contentsOf: toView)
        }
    }
    
    func projectToScreen() -> Bool {
        if let camera = self.camera {
            var clipped: Bool = false
            let fov = camera.fov 
            
            for i in 0..<toView.count {
                toScreen[i] = toView[i].xy
                if toScreen[i].y == 0 { toView[i].y = -1; clipped = true } // clip y if zero
                if toScreen[i].y != 0 { 
                    toScreen[i].x = toView[i].x * fov / toScreen[i].y + camera.w2 
                    toScreen[i].y = toView[i].z * fov / toScreen[i].y + camera.h2 
                }
            }
            
            return clipped
        }
        // failed projection (indicates invalid/erratic data left in projection)
        return true
    }
}
