import SwiftUI

class TransformerStage {
    // === Members ===
    internal var toView: [GLFloat3] = [.zero, .zero, .zero, .zero]
    // ToDo: continue implementing use of toScreen stage buffer (technically not necessary but makes intent clear
    internal var toScreen: [GLFloat2] = [.zero, .zero, .zero, .zero]
    
    internal var resolution: CGFloat = 1.0// cannot be zero (causes division by zero)
    internal var sine: CGFloat = 0.0
    internal var cosine: CGFloat = 1.0
    
    internal var camera: Camera? = nil
    
    // === Functions ===
    /** Gets the 3D view space coordinates result from the last transformation */
    func getToView(_ index: Int) -> GLFloat3 {
        if index >= 0 && index < 4 { return toView[index] } 
        else { return .zero }
    }
    /** Gets the 2D screen space coordinates result from the last transformation */
    func getToScreen(_ index: Int) -> CGPoint {
        if index >= 0 && index < 4 { return toScreen[index] } 
        else { return .zero }
    }
    
    func getCamera() -> Camera? { return camera }
    func setCamera(_ newCamera: Camera?) { 
        self.camera = newCamera
        let angle = newCamera != nil ? newCamera!.transform.a : 0
        self.cosine = MoGLMath.cos(angle)
        self.sine = MoGLMath.sin(angle)
    }
}
