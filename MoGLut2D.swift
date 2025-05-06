import SwiftUI
import Foundation

extension MoGL {
    
    func glRect2f(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat, 
                  _ x2: CGFloat, _ y2: CGFloat, _ x3: CGFloat, _ y3: CGFloat) {
        glVertexArray2f([Vector2(x0, y0), Vector2(x1, y1), Vector2(x2, y2), Vector2(x3, y3)])
    }
    
    func glPolygon2f(_ points: ArraySlice<Vector2>, _ connected: Bool = false, _ closed: Bool = true) {
        if points.count > 0, let first = points.first {
                if !connected { glMove2f(first) }
                for p in points { glVertex2f(p) }
                // close if at least three points (line and points don't need closing)
                if closed, points.count > 2 { glVertex2f(first) }
        }
    }
    func glPolygon2f(_ points: [Vector2], _ connected: Bool = false, _ closed: Bool = true) {
        if points.count > 0 {
            if !connected { glMove2f(points[0]) }
            for p in points { glVertex2f(p) }
            // close if at least two points
            if closed, points.count > 2 { glVertex2f(points[0]) }
        }
    }
    
    func glQuad2f(_ tl: Vector2, _ tr: Vector2, _ br: Vector2, _ bl: Vector2) {
        glMove2f(tl)
        glVertexArray2f([tr, br, bl, tl])
    }
    
    func glColoredQuad2f(_ tl: Vector2, _ tr: Vector2, _ br: Vector2, _ bl: Vector2, _ color: Color) {
        self.glFlush()
        self.glShading(.color(color))
        glQuad2f(tl, tr, br, bl)
        self.glSwap(draw: true)
    }
    
    func glColoredQuadStrip2f(_ tl: Vector2, _ tr: Vector2, _ br: Vector2, _ bl: Vector2, _ colors: [Color]) {
        let h = colors.count
        // need to sample the distorted delta for left and right
        let lDelta = (bl - tl) / CGFloat(h)
        let rDelta = (br - tr) / CGFloat(h)
        
        for y in 0..<h {
            let sTL = tl + (lDelta * CGFloat(y))
            let sTR = tr + (rDelta * CGFloat(y))
            
            let sBL = tl + (lDelta * CGFloat(y+1))
            let sBR = tr + (rDelta * CGFloat(y+1))
            
            glColoredQuad2f(sTL, sTR, sBR, sBL, colors[y])
        }
        
    }
    
    func glTexturedQuadStrip2f(_ tl: Vector2, _ tr: Vector2, _ br: Vector2, _ bl: Vector2, _ sampler: GLSampler) {
        let w = sampler.w
        let h = sampler.h
        let size = Vector2(x: CGFloat(w), y: CGFloat(h))
        
        let bDelta = Vector2(x: (br.x - bl.x) / size.x, y: (br.y - bl.y) / size.y)
        let tDelta = Vector2(x: (tr.x - tl.x) / size.x, y: (tr.y - tl.y) / size.y)
        
        for x in 0..<w {
            let xBL = bl + bDelta * CGFloat(x), xBR = bl + bDelta * CGFloat(x+1)
            let xTL = tl + tDelta * CGFloat(x), xTR = tl + tDelta * CGFloat(x+1)
            // need to sample the distorted delta for left and right
            let lDelta = (xBL - xTL) / size
            let rDelta = (xBR - xTR) / size
            
            for y in 0..<h {
                let sTL = xTL + (lDelta * CGFloat(y))
                let sTR = xTR + (rDelta * CGFloat(y))
                
                let sBL = xTL + (lDelta * CGFloat(y+1))
                let sBR = xTR + (rDelta * CGFloat(y+1))
                
                let clr = sampler.sample(x, y, mip: 0).unpackRGBA()
                glColoredQuad2f(sTL, sTR, sBR, sBL, Color(uiColor: clr))
            }
        }   
    }
    
    func glDrawPolygon(_ polygon: GLPolygon2D, with: GraphicsContext.Shading) {
        if polygon.isEmpty { return }
        self.glFlush()
        self.glShading(with)
        polygon.drawPolygon(self)
        self.glSwap(draw: true)
    }
    
}
