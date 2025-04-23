import SwiftUI

struct Lit: SurfaceShading {
    // === Static Members ===
    private static let litOffset: CGFloat = 0.1
    private static let shadedOffset: CGFloat = -0.1
    
    // === Members ===
    let lighten: Color
    let albedo: Color
    let darken: Color
    // ToDo: Reconsider materials system.
    //        material may provide base color/albedo
    //        material may provide secondary info for light pass
    //        material may provide secondary info for shading pass 
    //        should I start a depth pass that can be rendered to?
    
    // === Ctors ===
    init(albedo: Color) {
        self.albedo = albedo
        self.darken = albedo.mix(with: .black, by: Self.litOffset)
        self.lighten = albedo.mix(with: .white, by: Self.litOffset)
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
    func mapAngle(_ angle: Int) -> CGFloat {
        let result: CGFloat = abs(angle) != 0 ? (CGFloat(abs(angle)) / 180.0 * 0.5) : 0.0
        //        print ("Angle: \(angle) => \(result)")
        return result
    }
    
    func getGCShading(_ rd: RDBase) -> GraphicsContext.Shading {
        if rd.wa < 0 { return .color(albedo.mix(with: lighten, by: mapAngle(rd.wa))) }
        else if rd.wa > 0 { return .color(albedo.mix(with: darken, by: mapAngle(rd.wa))) }
        else { return .color(albedo) }
    }
}

extension Lit {
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
    
    static let lightGrayLit: TSelf = .init(ShadingPass(TShading.lightGray))   
    static let grayLit: TSelf = .init(ShadingPass(TShading.gray))
    static let darkGrayLit: TSelf = .init(ShadingPass(TShading.darkGray))      
    static let blackLit: TSelf = .init(ShadingPass(TShading.black))
    static let whiteLit: TSelf = .init(ShadingPass(TShading.white))
    static let redLit: TSelf = .init(ShadingPass(TShading.red))
    static let greenLit: TSelf = .init(ShadingPass(TShading.green))    
    static let blueLit: TSelf = .init(ShadingPass(TShading.blue))
}
