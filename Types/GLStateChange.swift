import SwiftUI

struct GLStateChange {
    public static let gsc_ccw_poly = GLStateChange(.ccw, .GL_POLY)
    public static let gsc_cw_poly = GLStateChange(.cw, .GL_POLY)
    
    
    let frontFace: GLWinding?
    let mode: GLMode?
    
    let clearColor: GraphicsContext.Shading?
    let shading: GraphicsContext.Shading?
    let lineWidth: CGFloat?
    let pointSize: CGFloat?
    
    init(_ frontFace: GLWinding?, _ mode: GLMode? = nil, 
         _ clearColor: GraphicsContext.Shading? = nil, 
         _ shading: GraphicsContext.Shading? = nil, 
         _ lineWidth: CGFloat? = nil, _ pointSize: CGFloat? = nil) {
        self.frontFace = frontFace
        self.mode = mode
        self.clearColor = clearColor
        self.shading = shading
        self.lineWidth = lineWidth
        self.pointSize = pointSize
    }
    
    func apply(_ gl: MoGL) {
        if frontFace != nil { gl.glFrontFace(frontFace!) }
        if mode != nil { gl.glMode(mode!) }
        
        if clearColor != nil { gl.glClearShading(clearColor!) }
        if shading != nil { gl.glShading(shading!) }
        if lineWidth != nil { gl.glLineWidth(lineWidth!) }
        if pointSize != nil { gl.glPointSize(pointSize!) }
    }
}
