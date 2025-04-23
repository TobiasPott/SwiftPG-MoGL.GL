import SwiftUI

struct Unlit: SurfaceShading {
    // === Members ===
    let albedo: GraphicsContext.Shading
    
    // === Ctors ===
    init(albedo: Color) {
        self.albedo = .color(albedo)
    }
    init(white: CGFloat, _ opacity: CGFloat = 1.0) {
        self.init(albedo: .init(.sRGB, white: white, opacity: opacity))
    }
    init(red: CGFloat, _ opacity: CGFloat = 1.0) { 
        self.init(albedo: .init(.sRGB, red: red, green: 0.0, blue: 0.0, opacity: opacity))
    }
    init(green: CGFloat, _ opacity: CGFloat = 1.0) {
        self.init(albedo: .init(.sRGB, red: 0.0, green: green, blue: 0.0, opacity: opacity))
    }
    init(blue: CGFloat, _ opacity: CGFloat = 1.0) { 
        self.init(albedo: .init(.sRGB, red: 0.0, green: 0.0, blue: blue, opacity: opacity))
    }
    
    // === Functions ===
    func getGCShading(_ rd: RDBase) -> GraphicsContext.Shading {
        return albedo 
    }
    func applyDoF(_ gl: MoGL, _ d: CGFloat) { }
}

extension Unlit {
    static let black: Self = Self.init(white: 0.1)
    static let lightGray: Self = Self.init(white: 0.25)
    static let gray: Self = Self.init(white: 0.45)
    static let darkGray: Self = Self.init(white: 0.7)
    static let white: Self = Self.init(white: 0.9)
    
    static let red: Self = Self.init(red: 0.9)
    static let darkRed: Self = Self.init(red: 0.4)
    static let green: Self = Self.init(green: 0.9)
    static let darkGreen: Self = Self.init(green: 0.4)
    static let blue: Self = Self.init(blue: 0.9)
    static let darkBlue: Self = Self.init(blue: 0.4)
}


extension SurfaceMaterial {
    private typealias TShading = Unlit
    
    static let lightGrayUnlit: TSelf = .init(ShadingPass(TShading.lightGray))    
    static let grayUnlit: TSelf = .init(ShadingPass(TShading.gray))
    static let darkGrayUnlit: TSelf = .init(ShadingPass(TShading.darkGray))      
    static let blackUnlit: TSelf = .init(ShadingPass(TShading.black))
    static let whiteUnlit: TSelf = .init(ShadingPass(TShading.white))
    static let redUnlit: TSelf = .init(ShadingPass(TShading.red))
    static let greenUnlit: TSelf = .init(ShadingPass(TShading.green))    
    static let blueUnlit: TSelf = .init(ShadingPass(TShading.blue))
}
