import SwiftUI

// = = == = = 
// Extension to integrate GLState into MoGL.gl.. calls
// = = == = = 
extension MoGL {
    
    func glMode(_ newMode: GLMode) { self.state.setMode(newMode) }
    func glFrontFace(_ newFrontFace: GLWinding) { self.state.setFrontFace(newFrontFace) }
    
    func glLineWidth(_ newLineWidth: CGFloat) { self.state.setLineWidth(newLineWidth) 
    }
    func glPointSize(_ newPointSize: CGFloat) { self.state.setPointSize(newPointSize) }
    
    func glClearColor3f(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) { state.setClearColor3f(r, g, b) }
    func glClearColor(_ newColor: Color) { state.setClearColor(newColor) }
    func glClearShading(_ newShading: GraphicsContext.Shading) { state.setClearShading(newShading) }
    
    
    func glColor3f(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) { state.setColor3f(r, g, b) }
    func glColor(_ newColor: Color) { state.setColor(newColor) }
    func glShading(_ newShading: GraphicsContext.Shading) { state.setShading(newShading) }
    
}
