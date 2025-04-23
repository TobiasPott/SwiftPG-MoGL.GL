import SwiftUI

final class GLAssets {
    static let shaders: GLShaderLibrary = GLShaderLibrary()
    
    
    
    
    final class Shaders {
        
        private static let _texQuad: ShaderFunction = ShaderFunction(library: GLAssets.shaders.library, name: "texQuad")
        static func texQuad(_ with: [Shader.Argument]) -> GraphicsContext.Shading { return .shader(_texQuad.dynamicallyCall(withArguments: with)) }
        
    }
}
