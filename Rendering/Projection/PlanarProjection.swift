import SwiftUI

// projects two vertical edges onto x/y plane
class PlanarProjection: TransformerStage, Projection {
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
        if let camera = self.camera {
            return toView.compactMap { i in i.z }.less(camera.nearClip)
        }
        return false
    }
    func cullFar() -> Bool {
        if let camera = self.camera {
            return toView.compactMap { i in i.z }.greater(camera.farClip)
        }
        return false
    }
    
    func clipNear() -> Bool { return false }
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
            let cameraZ = CGFloat(cameraTfs.z)
            
            //offset bottom 2 points by player
            let nP1 = (p1).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            let nP2 = (p2).rotate(cameraTfs.a, cameraLoc * -1, cosine, sine)
            
            let x1: CGFloat = (((nP1.x) - cameraTfs.x) / resolution)
            let y1: CGFloat = (((nP1.y) - cameraTfs.y) / resolution)
            
            let x2: CGFloat = (((nP2.x) - cameraTfs.x) / resolution)
            let y2: CGFloat = (((nP2.y) - cameraTfs.y) / resolution)
            
            //view X position 
            let x = [x1, x2, x2, x1]            
            //view Y position (depth)
            let y = [y1, y2, y2, y1]
            
            var z: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
            //view z position
            z[0] = cameraZ - ze1.min
            z[1] = cameraZ - ze2.min
            z[2] = cameraZ - ze2.max
            z[3] = cameraZ - ze1.max
            
            self.toView[0] = .init(x[0], y[0], z[0])
            self.toView[1] = .init(x[1], y[1], z[1])
            self.toView[2] = .init(x[2], y[2], z[2])
            self.toView[3] = .init(x[3], y[3], z[3])
        }
    }
    
    func projectToScreen() -> Bool {
        if let camera = self.camera {
            for i in 0..<toView.count {
                toScreen[i] = toView[i].xy + GLFloat2(camera.w2, camera.h2)
            }
        }
        
        return false
    }
}
