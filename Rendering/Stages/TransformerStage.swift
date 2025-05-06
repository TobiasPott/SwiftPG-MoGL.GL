import SwiftUI

class TransformerStage {
    // === Members ===
    internal var toView: [Vector3] = [.zero, .zero, .zero, .zero]
    // ToDo: continue implementing use of toScreen stage buffer (technically not necessary but makes intent clear
    internal var toScreen: [Vector2] = [.zero, .zero, .zero, .zero]
    
    internal var resolution: CGFloat = 1.0// cannot be zero (causes division by zero)
    internal var sine: CGFloat = 0.0
    internal var cosine: CGFloat = 1.0
    
    internal var viewTarget: ViewTarget? = nil
    
    // === Functions ===
    /** Gets the 3D view space coordinates result from the last transformation */
    func getToView(_ index: Int) -> Vector3 {
        if index >= 0 && index < 4 { return toView[index] } 
        else { return .zero }
    }
    /** Gets the 2D screen space coordinates result from the last transformation */
    func getToScreen(_ index: Int) -> Vector2 {
        if index >= 0 && index < 4 { return toScreen[index] } 
        else { return .zero }
    }
    
    func getViewTarget() -> ViewTarget? { return viewTarget }
    func setViewTarget(_ newViewTarget: ViewTarget?) { 
        self.viewTarget = newViewTarget
        let angle = newViewTarget != nil ? newViewTarget!.transform.a : 0
        self.cosine = MoGLMath.cos(angle)
        self.sine = MoGLMath.sin(angle)
    }
}
