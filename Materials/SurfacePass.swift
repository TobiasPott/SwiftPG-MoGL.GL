import SwiftUI

struct ShadingPass: SurfaceShading {
    // === Members ===
    let name: PassName
    let shading: SurfaceShading
    let state: GLStateChange
    
    // === Ctors ===
    init(_ name: PassName, _ surfaceShading: SurfaceShading, _ state: GLStateChange) {
        self.name = name
        self.shading = surfaceShading
        self.state = state
    }
    init(_ surfaceShading: SurfaceShading) {
        self.name = .albedo
        self.shading = surfaceShading
        self.state = .gsc_ccw_poly
    }
    
    
    // === Functions ===
    func getGCShading(_ rd: RDBase) -> GraphicsContext.Shading { return shading.getGCShading(rd) }
    
    // === Nested Types ===    
    struct PassName: RawRepresentable {
        var rawValue: String
        static let albedo: Self = .init(rawValue: "albedo")
        static let light: Self = .init(rawValue: "light")
        static let shadow: Self = .init(rawValue: "shadow")
        static let depth: Self = .init(rawValue: "depth")
    }
    
}
