import SwiftUI

//https://gamedev.stackexchange.com/questions/159434/how-to-convert-3d-coordinates-to-2d-isometric-coordinates
// projects zwo vertical edges onto x/y plane
class IsometricProjection: TransformerStage, Projection {
    // === Members ===
    private var isoUnit: Int // cannot be zero (causes division by zero)
    // === Properties ===
    var winding: GLWinding { get { return (x[1] > x[0]) ? .ccw : .cw } }
    
    // === Ctors ===
    init(_ newResolution: CGFloat, _ isoUnit: Int) {
        self.isoUnit = isoUnit <= 0 ? 1 : isoUnit
        super.init()
        self.resolution = newResolution.isZero ? 1.0 : newResolution
    }
    
    // === Functions ===
    func cull(_ winding: GLWinding = GLWinding.ccw) -> Bool {
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
        //            var clipped: Bool = false
        //            return clipped
        //        }
        return false
    }
    func distanceTo2D(_ location: CGPoint) -> CGFloat {
        return (MoGLMath.dist2f(location.x, location.y, CGFloat(x[0] + x[1]) / 2.0, CGFloat(y[0] + y[1]) / 2.0))
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) {
        if let camera = self.camera {
            let cameraTfs = camera.transform
            let cameraLoc = cameraTfs.location
            
            //offset bottom 2 points by player
            let nP1 = (p1).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            let nP2 = (p2).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            
            let x1: CGFloat = (((nP1.x) - cameraTfs.x) / resolution)
            let y1: CGFloat = (((nP1.y) - cameraTfs.y) / resolution)
            
            let x2: CGFloat = (((nP2.x) - cameraTfs.x) / resolution)
            let y2: CGFloat = (((nP2.y) - cameraTfs.y) / resolution)
            
            //view X position 
            x[0] = (x1)
            x[1] = (x2)
            x[2] = (x2)
            x[3] = (x1)
            
            //view Y position (depth)
            y[0] = (y1)
            y[1] = (y2)
            y[2] = (y2) + Int(CGFloat(ze2.height) / CGFloat(isoUnit))
            y[3] = (y1) + Int(CGFloat(ze1.height) / CGFloat(isoUnit))
            
            //view z position
            z[0] = -(-ze1.min + CGFloat(cameraTfs.z))
            z[1] = -(-ze2.min + CGFloat(cameraTfs.z))
            z[2] = -(-ze2.max - CGFloat(cameraTfs.z))
            z[3] = -(-ze1.max - CGFloat(cameraTfs.z)) 
            
            z[3] = (ze1.min - CGFloat(cameraTfs.z) + (y[3] / resolution)) 
            z[2] = (ze2.min - CGFloat(cameraTfs.z) + (y[2] / resolution))
            z[1] = (ze2.max - CGFloat(cameraTfs.z) + (y[1] / resolution))
            z[0] = (ze1.max - CGFloat(cameraTfs.z) + (y[0] / resolution))
        }
    }
    
    func projectToScreen() -> Bool {
        if let camera = self.camera {
            let w2 = (camera.w2)
            let h2 = 0.0 // (camera.h2)
            
            //screen X position 
            x[0] = (x[0] + w2)
            x[1] = (x[1] + w2)
            x[2] = (x[2] + w2)
            x[3] = (x[3] + w2)
            
            //screen Y position
            y[0] = (y[0] + h2)
            y[1] = (y[1] + h2)
            y[2] = (y[2] + h2)
            y[3] = (y[3] + h2)
        }
        
        return false
    }
}
