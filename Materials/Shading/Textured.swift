import SwiftUI

struct Textured: SurfaceShading {
    // === Members ===
    var shared: GLShaderArgs = GLShaderArgs(count: 1) 
    
    // === Ctors ===
    init(texImage: Image) {
        // shared args will be appended to SurfaceMaterial.vertexData when using the material for drawing 
        shared[0] = .image(texImage)
    }
    
    // === Functions ===
    func mapAngle(_ angle: Int) -> CGFloat {
        let result: CGFloat = abs(angle) != 0 ? (CGFloat(abs(angle)) / 180.0 * 0.5) : 0.0
        //        print ("Angle: \(angle) => \(result)")
        return result
    }
    
    func getGCShading(_ rd: RDBase) -> GraphicsContext.Shading {
        let uniformData = GLShaderArgs.uniform([SurfaceMaterial.vertexData, shared])
        return GLAssets.Shaders.texQuad(uniformData)
    }
}

extension SurfaceMaterial {
    private typealias TShading = Textured
    
    static let checkerTextured: TSelf = .init(ShadingPass(TShading(texImage: Image("UVChecker8"))))
}
