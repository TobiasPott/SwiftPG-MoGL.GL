import SwiftUI

protocol SurfaceShading {    
    // add overload for get to accept RDBase for the first four arguments and camera for last two
    // ToDo: add Camera? property to protocol to enforce getter/setter for SurfaceShadings
    func getGCShading(_ rd: RDBase) -> GraphicsContext.Shading
}

class SurfaceMaterial {
    typealias TSelf = SurfaceMaterial
    // uniform data is a predecessor for material block similar layer of data which can be set by RDBase and retrieved by SurfaceMaterial as required without adding complexity to methods (for the price of hiding clearity for material requirements
    
    // === Static Members ===
    public static var globalData: GLShaderArgs = GLShaderArgs(count: 0)
    public static var vertexData: GLShaderArgs = GLShaderArgs(count: 4)
    
    // === Members ===
    let passes: [ShadingPass]
    
    // === Ctors ===
    required init(_ passes: [ShadingPass]) {
        self.passes = passes
    }
    required init(_ mainPass: ShadingPass) {
        self.passes = [mainPass]
    }
}

