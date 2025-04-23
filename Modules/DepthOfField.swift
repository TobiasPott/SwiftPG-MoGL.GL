import SwiftUI

// ToDo: Rename/Rework DepthOfField to MoGLExt as it is heavily dependent on SwiftUI features not available on non Apple platforms

final class DepthOfField: MoGLExtension {
    static let ExtensionName: String = "EXT_DepthOfField"
    static var enabled: Bool = false
    static var dofStart: CGFloat = 256
    static var dofEnd: CGFloat = 512
    static var dofStrength: CGFloat = 0.35
    
    
    init() { super.init(id: Self.ExtensionName) }
    
    // ToDo: extend extension type to hold gl reference
    // ToDo: extend to allow the function to retrieve/use parameters from the extension 
    //        e.g. dof start, dof range, dof strength
    static var depthOfFieldFunc: ContextFloatDelegate? = { ctx, d in
        let rD = CGFloat(d)
            .remap(iLow: DepthOfField.dofStart, iHigh: DepthOfField.dofEnd, 
                   oLow: 0, oHigh: DepthOfField.dofStrength)
            .clamp(0.0, DepthOfField.dofStrength)
        if rD > 0.0 {
            var newCtx = ctx
            newCtx.addFilter(.blur(radius: rD, options: .dithersResult))
            return newCtx
        }
        return ctx
    }
    
}

extension MoGL {
    func glDepthOfFieldFunc(_ newFunc: ContextFloatDelegate?) { DepthOfField.depthOfFieldFunc = newFunc }
    func glExtDepthOfField(_ d: CGFloat) {
        if DepthOfField.enabled, 
            let ctx = context, 
            let dotFunc = DepthOfField.depthOfFieldFunc { context = dotFunc(ctx, d) }
    }
    
}
