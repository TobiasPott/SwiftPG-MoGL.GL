import SwiftUI

enum ProjectionMode {
    case onePoint, planar, isometric
}

class Camera: ObservableObject, ViewTarget {
    // === Members ===
    @Published var transform: Transform = Transform() 
    @Published var fov: CGFloat = 200.0
    @Published var nearClip: CGFloat = 0.1
    @Published var farClip: CGFloat = 512.0
    @Published var viewport: CGRect = CGRect(x: 0, y: 0, width: 320, height: 240 * 2.0)
    @Published private var _projectionMode: ProjectionMode = .onePoint
    @Published private var _projection: Projection

    private var isoProj: IsoProjection = IsoProjection(1)
    private var onePointProj: OnePointProjection = OnePointProjection(128)
    private var planarProj: PlanarProjection = PlanarProjection(1)
    
    
    // === Properties ===
    var projection: Projection { get { return _projection } }
    var projectionType: ProjectionMode { get { return _projectionMode } } 
    
    // === Ctors ===
    init() {
        _projection = onePointProj
        //        _projection = isoProj
        _projection.setViewTarget(self)
        transform.move(0, -100, 0)
    }
    
    // === Functions ===
    func updateProjection() {
        projection.setViewTarget(self)
    }
    func getRenderViewport(_ renderScale: CGFloat = 1.0) -> CGRect { 
        return CGRect(origin: viewport.origin, size: viewport.size * renderScale) 
    }
    func reset() -> Void {
        fov = 200
        nearClip = 0
        farClip = 512
    }
    func setProjection(_ newType: ProjectionMode) {
        self._projectionMode = newType
        switch _projectionMode {
        case .onePoint: _projection = onePointProj; break;
        case .planar: _projection = planarProj; break;
        case .isometric: _projection = isoProj; break;
        }
    }
    
}
