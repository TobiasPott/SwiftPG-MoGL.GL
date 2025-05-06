///
/// Mock GL classes and helper to recreate GL calls for SwiftUI GraphicsContext
///
import SwiftUI

typealias ContextFloatDelegate = (GraphicsContext, CGFloat) -> GraphicsContext


class MoGL {
    // === Members ===
    private var buffer: GLPathBuffer = GLPathBuffer()
    internal var state: GLState = GLState()
    private var viewport: CGRect = .init(x: 0, y: 0, width: 320, height: 240)
    var context: GraphicsContext?

    // === Properties ===    
    
    // === Functions ===
    func glContext(_ newContext: GraphicsContext) { self.context = newContext }
    
    func glViewport(_ newViewport: CGRect) { self.viewport = newViewport }
    func glDraw() {
        switch state.mode {
        case .GL_LINE: glDrawLine(); break;
        case .GL_POLY: glDrawPoly(); break;
        case .GL_POINTS: glDrawPoints(); break;
        }
    }
    private func glDrawLine() {
        context?.stroke(buffer.getBuffer(.front), with: state.shading, style: state.strokeStyle)
    }
    private func glDrawPoly() {
        context?.fill(buffer.getBuffer(.front), with: state.shading)
    } 
    private func glDrawPoints() {
        let path = buffer.getBuffer(.front)
        path.forEach { element in
            switch element {
            case .move(to: let point), .line(to: let point): 
                context?.point(at: point, with: state.shading, size: state.pointSize)
            default: break;
            }
        } 
    }
    
    func glClear(_ with: GraphicsContext.Shading? = nil) {
        context?.fill(Path(viewport), with: with ?? state.clearColor)
    }
    
    // Consider adding glDraw to the swap call (or add argument to call it)
    //    as I seem to use it in conjunction most of the time
    func glSwap(draw: Bool = false) {
        buffer.swap()
        if draw { glDraw() }
    }
    func glFlush(_ targets: [GLBufferTarget] = [.back, .front]) {
        buffer.flush(targets)
    }
    
    func glFaceCull(_ winding: GLWinding) -> Bool {
        if state.frontFace == .none { return false }
        return state.frontFace == winding 
    }
    
    
    
    func glTranslate(_ translation: CGPoint) {
        let tfs: CGAffineTransform = .identity.translatedBy(x: translation.x, y: translation.y)
        buffer.back = buffer.back.transform(tfs).path(in: viewport)
    }
    func glTranslate2f(_ x: CGFloat, _ y: CGFloat) {
        let tfs: CGAffineTransform = .identity.translatedBy(x: x, y: y)
        buffer.back = buffer.back.transform(tfs).path(in: viewport)
    }
    func glScale(_ scale: Vector2) {
        buffer.back = buffer.back.scale(x: scale.x, y: scale.y, anchor: .center).path(in: viewport)
    }
    func glScale2f(_ x: CGFloat, _ y: CGFloat) {
        buffer.back = buffer.back.scale(x: x, y: y, anchor: .center).path(in: viewport)
    }
    func glRotate1f(_ angle: CGFloat) {
        buffer.back = buffer.back.rotation(Angle(degrees: angle), anchor: .center).path(in: viewport)        
    }
    
    // =========
    // base line and move functions
    func glMove2f(_ pt: Vector2) { glVertex2f(pt, false) }
    func glVertex2f(_ pt: Vector2, _ connect: Bool = true) {    
        if connect { buffer.back.addLine(to: pt.cgPoint) } 
        else { buffer.back.move(to: pt.cgPoint) }
    }
    func glVertexArray2f(_ pts: [Vector2], _ connect: Bool = true) {
        if pts.isEmpty { return }
        // handle connect with first entry in array
        if connect { buffer.back.addLine(to: pts[0].cgPoint) } 
        else { buffer.back.move(to: pts[0].cgPoint) }
        // add all others as lines
        for i in 1..<pts.count { buffer.back.addLine(to: pts[i].cgPoint) }
    }
    
}
