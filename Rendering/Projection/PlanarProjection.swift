import SwiftUI

// projects two vertical edges onto x/y plane
class PlanarProjection: TransformerStage, Projection {
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
        // ToDo: check culling in planar
        return cullNear() || cullFar()
    }
    
    private func cullNear() -> Bool {
        if let camera = self.camera {
            return z.less(camera.nearClip)
        }
        return false
    }
    private func cullFar() -> Bool {
        if let camera = self.camera {
            return z.greater(camera.farClip)
        }
        return false
    }
    
    func clipNear() -> Bool {        
        //        if let camera = self.camera {
        //            if z[0] < camera.nearClip && z[1] < camera.nearClip 
        //                && z[2] < camera.nearClip && z[3] < camera.nearClip { 
        //                return true 
        //            }
        //        }
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
            let cameraLoc = cameraTfs.location
            let cameraZ = CGFloat(cameraTfs.z)
            
            //offset bottom 2 points by player
            let nP1 = (p1).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            let nP2 = (p2).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            
            let x1: CGFloat = (((nP1.x) - cameraTfs.x) / resolution)
            let y1: CGFloat = (((nP1.y) - cameraTfs.y) / resolution)
            
            let x2: CGFloat = (((nP2.x) - cameraTfs.x) / resolution)
            let y2: CGFloat = (((nP2.y) - cameraTfs.y) / resolution)
            
            //view X position 
            x = [x1, x2, x2, x1]            
            //view Y position (depth)
            y = [y1, y2, y2, y1]
            
            //view z position
            z[0] = cameraZ - ze1.min
            z[1] = cameraZ - ze2.min
            z[2] = cameraZ - ze2.max
            z[3] = cameraZ - ze1.max
        }
    }
    
    func projectToScreen() -> Bool {
        if let camera = self.camera {    
            //screen X position 
            x += camera.w2
            //screen Y position
            y += camera.h2
        }
        
        return false
    }
}
