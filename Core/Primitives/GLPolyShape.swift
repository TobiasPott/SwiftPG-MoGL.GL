import SwiftUI

class GLPolyShape: GLPolygon2D {
    // === Members ===
    var connected: Bool = false
    var closed: Bool = true
    var transform: Transformation? = nil
    
    // === Ctors ===
    convenience init(_ points: [Vector2], _ options: Flags) { self.init(points, nil, options) }
    init(_ points: [Vector2], _ transform: Transformation? = nil, _ options: Flags) {
        super.init()
        self.append(contentsOf: points)
        self.transform = transform
        self.connected = options.contains(.connected)
        self.closed = options.contains(.closed)
    }   
    
    // === Functions ===
    override func drawPolygon(_ gl: MoGL, _ options: Flags = .none) {
        if !isEmpty {
            if let tfs = transform {
                gl.glTranslate2f(-tfs.location.x, -tfs.location.y)
                gl.glPolygon2f(self.vertices, options.contains(.connected), options.contains(.closed))
                gl.glTranslate2f(tfs.location.x, tfs.location.y)
            } else {
                gl.glPolygon2f(self.vertices, options.contains(.connected), options.contains(.closed))
            }
        }
    }
}
