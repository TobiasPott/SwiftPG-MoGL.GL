import SwiftUI

class GLPolyShape: GLPolygon {
    // === Members ===
    var connected: Bool = false
    var closed: Bool = true
    var transform: Transformation? = nil
    
    // === Ctors ===
    convenience init(_ points: [CGPoint], _ options: Flags) { self.init(points, nil, options) }
    init(_ points: [CGPoint], _ transform: Transformation? = nil, _ options: Flags) {
        super.init()
        self.append(vertices: points)
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
