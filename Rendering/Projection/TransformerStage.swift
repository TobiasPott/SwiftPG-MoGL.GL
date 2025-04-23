import SwiftUI

class TransformerStage {
    // === Members ===
    internal var x: [CGFloat] = [0, 0, 0, 0]
    internal var y: [CGFloat] = [0, 0, 0, 0]
    internal var z: [CGFloat] = [0, 0, 0, 0]
    
    internal var resolution: CGFloat = 1.0// cannot be zero (causes division by zero)
    internal var sine: CGFloat = 0.0
    internal var cosine: CGFloat = 1.0
    
    internal var camera: Camera? = nil
    
    // === Functions ===
    func get2D(_ index: Int) -> CGPoint {
        if index >= 0 && index < 4 {
            return .init(x: x[index], y: y[index]) 
        } else { return .zero }
    }
    func get3D(_ index: Int) -> GLFloat3 {
        if index >= 0 && index < 4 {
            return .init(x: x[index], y: y[index], z: z[index]) 
        } else { return .zero }
    }
    
    func getCamera() -> Camera? { return camera }
    func setCamera(_ newCamera: Camera?) { 
        self.camera = newCamera
        let angle = newCamera != nil ? newCamera!.transform.a : 0
        self.cosine = MoGLMath.cos(angle)
        self.sine = MoGLMath.sin(angle)
    }
}
