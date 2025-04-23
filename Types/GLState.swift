import SwiftUI

enum GLWinding {
    case none, cw, ccw
}

enum GLMode {
    case GL_POINTS, GL_LINE, GL_POLY
}

// ToDo: extend state to map context properties like opacity, blendMode and blur to pseudo 'GL' states
//        opacity is mapped to float
//        blendMode may be skipped for now
//        blur is mapped with a distance-function which receives d and dz, near/far to map onto a blur factor
//        fog is mapped with distance function which uses d and dz, near/far to calc a fog coverage 
//            fog may be better placed into the Shading part of the material system

class GLState: ObservableObject {
    private(set) var strokeStyle: StrokeStyle = .init(lineWidth: 1.0, lineCap: .round, lineJoin: .round, miterLimit: 5.0)
    
    
    var frontFace: GLWinding = .ccw
    var mode: GLMode = .GL_LINE
    
    var clearColor: GraphicsContext.Shading = .linearGradient(.init(colors: [.gray, .init(.sRGB, white: 0.7, opacity: 1.0)]), startPoint: .init(0, 0), endPoint: .init(0, 240))
    
    var shading: GraphicsContext.Shading = .color(.gray)
    var lineWidth: CGFloat = 5.0
    var pointSize: CGFloat = 5.0
    
    
    func setMode(_ newMode: GLMode) { self.mode = newMode }
    func setFrontFace(_ newFrontFace: GLWinding) { self.frontFace = newFrontFace }
    func setLineWidth(_ newLineWidth: CGFloat) { 
        self.lineWidth = newLineWidth
        self.strokeStyle = .init(lineWidth: newLineWidth, lineCap: .round, lineJoin: .round, miterLimit: 5.0)
    }
    func setPointSize(_ newPointSize: CGFloat) { self.pointSize = newPointSize }
    func setClearColor3f(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) { 
        self.clearColor = .color(Color(.sRGB, red: r, green: g, blue: b, opacity: 1.0)) 
    }    
    func setClearColor(_ newColor: Color) { self.clearColor = .color(newColor) }
    func setClearShading(_ newShading: GraphicsContext.Shading) { self.clearColor = newShading }
    func setColor3f(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) { 
        self.shading = .color(Color(.sRGB, red: r, green: g, blue: b, opacity: 1.0))
    }
    func setColor(_ newColor: Color) { self.shading = .color(newColor) }
    func setShading(_ newShading: GraphicsContext.Shading) { self.shading = newShading }
    
}
