import SwiftUI

class GLShaderLibrary {
    let library: ShaderLibrary
    
    // ToDo: Extent shader library by variant which accepts a 0-1 range lerp between dim and lit texture
    
    init(resourceName: String = "default-ios") {
        // Experimental: sample using the texQuad shader function to map texture to canvas
        if let fileURL = Bundle.main.url(forResource: resourceName, withExtension: "metallib") {
            library = ShaderLibrary(url: fileURL)
        } else { library = ShaderLibrary.default}
    }
}
