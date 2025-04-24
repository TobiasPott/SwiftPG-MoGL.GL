import SwiftUI

// one-vanishing-point-perspective
class OnePointProjection: TransformerStage, Projection {
    // === Members ===
    // === Properties ===
    var winding: GLWinding { get { return (x[1] > x[0]) ? .ccw : .cw } }
    
    // === Ctors ===
    init(_ newResolution: CGFloat) {
        super.init()
        self.resolution = newResolution.isZero ? 1.0 : newResolution
    }
    
    // === Functions ===    
    func cull(_ winding: GLWinding = GLWinding.ccw) -> Bool {
        return cullNear() 
        || cullFar()
    }
    private func cullNear() -> Bool {
        if let camera = self.camera {
            return y.less(camera.nearClip)
        }
        return false
    }
    private func cullFar() -> Bool {
        if let camera = self.camera {
            return y.greater(camera.farClip)
        }
        return false
    }
    
    func clipNear() -> Bool {
        if let camera = self.camera {
            var clipped: Bool = false
            if y[0] <= camera.nearClip { y[0] = camera.nearClip + 1; clipped = true }
            if y[1] <= camera.nearClip { y[1] = camera.nearClip + 1; clipped = true }
            if y[2] <= camera.nearClip { y[2] = camera.nearClip + 1; clipped = true }
            if y[3] <= camera.nearClip { y[3] = camera.nearClip + 1; clipped = true }
            return clipped
        }
        return false
    }
    func distanceTo2D(_ location: CGPoint) -> CGFloat {
        return (MoGLMath.dist2f(location.x, location.y, CGFloat(x[0] + x[1]) / 2.0, CGFloat(y[0] + y[1]) / 2.0))
    }
    func projectToView(_ pb1: GLFloat3, _ pb2: GLFloat3, _ pt1: GLFloat3, _ pt2: GLFloat3) {
        // ToDo: transfer from projectToView(CGPoint..)
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) {
        if let camera = self.camera {
            let cameraTfs = camera.transform
            //            let cameraLoc = cameraTfs.location
            
            //offset bottom 2 points by player
            let np1 = p1 - cameraTfs.location 
            let x1: CGFloat = np1.x
            let y1: CGFloat = np1.y
            
            let np2 = p2 - cameraTfs.location
            let x2: CGFloat = np2.x
            let y2: CGFloat = np2.y
            
            //view X position
            x[0] = (x1 * cosine - y1 * sine);
            x[1] = (x2 * cosine - y2 * sine);
            x[2] = (x[1])
            x[3] = (x[0])
            
            //view Y position (depth)
            y[0] = (y1 * cosine + x1 * sine)
            y[1] = (y2 * cosine + x2 * sine)
            y[2] = (y[1]) 
            y[3] = (y[0])
            
            //view z height
            z[3] = (ze1.min - CGFloat(cameraTfs.z) + (y[0] / resolution)) 
            z[2] = (ze2.min - CGFloat(cameraTfs.z) + (y[1] / resolution))
            z[1] = (ze2.max - CGFloat(cameraTfs.z) + (y[1] / resolution))
            z[0] = (ze1.max - CGFloat(cameraTfs.z) + (y[0] / resolution))
        }
    }
    
    func projectToScreen() -> Bool {
        if let camera = self.camera {
            var clipped: Bool = false
            
            let fov = camera.fov 
            let w2 = (camera.w2)
            let h2 = (camera.h2)
            
            if y[0] == 0 { y[0] = -1; clipped = true } // clip first y if zero
            if y[0] != 0 { x[0] = x[0] * fov / y[0] + w2 }
            if y[0] != 0 { y[0] = z[0] * fov / y[0] + h2 }
            
            if y[1] == 0 { y[1] = -1; clipped = true } // clip second y if zero
            if y[1] != 0 { x[1] = x[1] * fov / y[1] + w2 }
            if y[1] != 0 { y[1] = z[1] * fov / y[1] + h2 }
            
            if y[2] == 0 { y[2] = -1; clipped = true } // clip third y if zero
            if y[2] != 0 { x[2] = x[2] * fov / y[2] + w2 }
            if y[2] != 0 { y[2] = z[2] * fov / y[2] + h2 }
            
            if y[3] == 0 { y[3] = -1; clipped = true } // clip fourth y if zero
            if y[3] != 0 { x[3] = x[3] * fov / y[3] + w2 }
            if y[3] != 0 { y[3] = z[3] * fov / y[3] + h2 }
            
            return clipped
        }
        // failed projection (indicates invalid/erratic data left in projection)
        return true
    }
}
