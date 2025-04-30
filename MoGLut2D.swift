import SwiftUI
import Foundation

extension MoGL {
    
    func glRect2f(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat, 
                  _ x2: CGFloat, _ y2: CGFloat, _ x3: CGFloat, _ y3: CGFloat) {
        glVertexArray2f([CGPoint(x0, y0), CGPoint(x1, y1), CGPoint(x2, y2), CGPoint(x3, y3)])
    }
    func glRect2i(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat, 
                  _ x2: CGFloat, _ y2: CGFloat, _ x3: CGFloat, _ y3: CGFloat) {
        glVertexArray2i([CGPoint(x0, y0), CGPoint(x1, y1), CGPoint(x2, y2), CGPoint(x3, y3)])
    }
    
    func glPolygon2f(_ points: ArraySlice<CGPoint>, _ connected: Bool = false, _ closed: Bool = true) {
        if points.count > 0, let first = points.first {
                if !connected { glMove2f(first) }
                for p in points { glVertex2f(p) }
                // close if at least three points (line and points don't need closing)
                if closed, points.count > 2 { glVertex2f(first) }
        }
    }
    
    func glPolygon2f(_ points: [CGPoint], _ connected: Bool = false, _ closed: Bool = true) {
        if points.count > 0 {
            if !connected { glMove2f(points[0]) }
            for p in points { glVertex2f(p) }
            // close if at least two points
            if closed, points.count > 2 { glVertex2f(points[0]) }
        }
    }
//    func glPolygon2i(_ points: [CGPoint], _ connected: Bool = false, _ closed: Bool = true) {
//        if points.count > 0 {
//            if !connected { glMove2i(points[0]) }
//            for p in points { glVertex2i(p) }
//            // close if at least two points
//            if closed, points.count > 1 { glVertex2i(points[0]) }
//        }
//    }
    
    func glQuad2f(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint) {
        glMove2f(tl)
        glVertexArray2f([tr, br, bl, tl])
    }
//    func glQuad2i(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint) {
//        glMove2i(tl)
//        glVertexArray2i([tr, br, bl, tl])
//    }
    
    func glColoredQuad2f(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint, _ color: Color) {
        self.glFlush()
        self.glShading(.color(color))
        glQuad2f(tl, tr, br, bl)
        self.glSwap(draw: true)
    }
//    func glColoredQuad2i(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint, _ color: Color) {
//        self.glFlush()
//        self.glShading(.color(color))
//        glQuad2i(tl, tr, br, bl)
//        self.glSwap(draw: true)
//    }
    
    func glColoredQuadStrip2f(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint, _ colors: [Color]) {
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
    
    func glTexturedQuadStrip2f(_ tl: CGPoint, _ tr: CGPoint, _ br: CGPoint, _ bl: CGPoint, _ sampler: GLSampler) {
        let w = sampler.w
        let h = sampler.h
        let size = CGPoint(x: w, y: h)
        
        let bDelta = CGPoint(x: (br.x - bl.x) / CGFloat(w), y: (br.y - bl.y) / CGFloat(h))
        let tDelta = CGPoint(x: (tr.x - tl.x) / CGFloat(w), y: (tr.y - tl.y) / CGFloat(h))
        
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
    
    func glPolygon(_ polygon: GLPolygon2D) {
        polygon.drawPolygon(self)
    }
    func glPolygons(_ polygons: [GLPolygon2D]) {
        for p in polygons.sorted(by: { lh, rh in return lh.fragment < rh.fragment }) {
            p.drawPolygon(self)
        }
    }
    func glDrawPolygon(_ polygon: GLPolygon2D, with: GraphicsContext.Shading) {
        if polygon.isEmpty { return }
        self.glFlush()
        self.glShading(with)
        polygon.drawPolygon(self)
        self.glSwap(draw: true)
    }
    func glDrawPolygons(_ polygons: [GLPolygon2D], with: GraphicsContext.Shading) {
        if polygons.isEmpty { return }
        self.glFlush()
        self.glShading(with)
        for p in polygons.sorted(by: { lh, rh in return lh.fragment < rh.fragment }) {
            p.drawPolygon(self)
        }        
        self.glSwap(draw: true)
    }
    
}
