import SwiftUI

enum ProjectionMode {
    case onePoint, planar, isometric
}

class Camera: ObservableObject {
    // === Members ===
    @Published var transform: Transform = Transform() 
    @Published var fov: CGFloat = 200.0
    @Published var nearClip: CGFloat = 0.1
    @Published var farClip: CGFloat = 512.0
    @Published var viewport: CGRect = CGRect(x: 0, y: 0, width: 320, height: 240 * 2.0)
    @Published private var _projectionMode: ProjectionMode = .onePoint
    @Published private var _projection: Projection

    private var isoProj: IsometricProjection = IsometricProjection(1, 1)
    private var onePointProj: OnePointProjection = OnePointProjection(64)
    private var planarProj: PlanarProjection = PlanarProjection(1)
    
    
    // === Properties ===
    var aspect: CGFloat { get { return viewport.width / viewport.height } }
    var w2: CGFloat { get { return (viewport.width / 2) } }
    var h2: CGFloat { get { return (viewport.height / 2) } }
    
    var projection: Projection { get { return _projection } }
    var projectionType: ProjectionMode { get { return _projectionMode } } 
    
    
    // === Ctors ===
    init() {
        _projection = onePointProj
        //        _projection = isoProj
        _projection.setCamera(self)
        transform.move(0, -100, 0)
    }
    
    // === Functions ===
    func updateProjection() {
        projection.setCamera(self)
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
