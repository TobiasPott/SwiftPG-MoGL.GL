import SwiftUI

struct Widget: Renderable {
    
    let gl: MoGL
    func update(camera: Camera) { }
    func draw(_ gl: MoGL, camera: Camera) {
        //        if let context = gl.context {
        //            context.opacity = 0.5
        // scale canvas so everything drawn is scaled up (draw scale is matched with scaled view size)
        //            context.scaleBy(x: scale, y: scale)
        //            gl.glContext(context)
        
        Widget.p0.drawPolygon(gl, [.closed])
        gl.glSwap(draw: false)
        gl.glMode(.GL_POINTS)
        gl.glDraw()
        gl.glMode(.GL_LINE)
        gl.glDraw()
        // Somewhat working gradient, though has many artifacts on strongly skewed polygons
        
        // ToDo: Ponder about a formula to derive the lerp interpolation from the stretch of the polygon 
        //    the angle to horizontal screen axis between 0 and 90 should allow to map towards the lerp factor?!
        // distortion doesn't work with top and bottom edge diagonal
        // maybe I can fiddle with a double gradient setup to draw the upper half and then the lower half, each drawing clear color for the 'not' drawn part
        //            let tl = CGPoint(x: 140, y: 70)
        //            let tr = CGPoint(x: 200, y: 40)
        //            let br = CGPoint(x: 200, y: 180)
        //            let bl = CGPoint(x: 140, y: 140)
        //            let clrs: [Color] = [.white, .blue, .green, .green, .red, .black]
        //            
        //            
        //             let clrT: [Color] = Array(clrs.dropLast(3)) + [.green]
        //             let clrB: [Color] = [.clear] + Array(clrs.dropFirst(3))
        //             gl.glQuad2f(tl, tr, br, bl)
        //             gl.glSwap()
        //             
        
        /*
         let cen = (tr + tl + br + bl) / 4.0
         let tCenter = (tr + tl) / 2.0
         let bCenter = (br + bl) / 2.0
         let tDist = (tCenter - cen).magnitude() * 1.15
         let bDist = (cen - bCenter).magnitude() * 1.15
         
         let tDir = (tr - tl).normalized().rotate(90, .zero)
         let bDir = (br - bl).normalized().rotate(-90, .zero)
         
         print("\(tDist) -> \(tDir) \(cen) \(tCenter)")
         let tStart = tCenter
         let tEnd = tCenter + tDir * tDist
         */
        /*
         gl.glShading(GraphicsContext.Shading
         .verticalGradient(clrT, tStart, tEnd, [.linearColor]))
         gl.glDraw()
         
         gl.glShading(GraphicsContext.Shading
         .verticalGradient(clrB, bCenter + bDir * bDist, bCenter, [.linearColor]))
         gl.glDraw()
         */
        //            let yOffset = 20.0
        //            let offset: CGPoint = CGPoint(x: 10, y: 0)
        /*
         gl.glColoredQuadStrip2f(.init(40, 40), .init(x: 120, y: 70 + yOffset),
         .init(x: 120, y: 100 + yOffset), .init(60, 120),
         [.red, .green, .blue, .red, .green, .blue, .red, .green].reversed())
         */
        /*
         var sampler: GLSampler = GLSampler(4, 4, solid: .black)
         sampler.mipMaps[0] = GLSampler.missing8.mipMaps[0].sub(inRect: CGRect(x: 0, y: 0, width: 4, height: 4), strideLength: 8)
         
         gl.glContext(context)
         gl.glTexturedQuadStrip2f(offset + .init(40, 40), 
         offset + .init(x: 120, y: 70 + yOffset),
         offset + .init(x: 120, y: 100 + yOffset), 
         offset + .init(40, 140),
         // sampler)
         GLSampler.missing8)
         
         context.opacity = 1.0
         gl.glContext(context)
         */
        // debug draw stuff directly on top of everything rendered before (aka IMGUI)
        //            drawImGUI(gl)
        //        }
        //        }
    }
    
}

extension Widget {
    static let p0: GLPolyShape = GLPolyShape([.init(120, 10), .init(120, 20), .init(180, 20), .init(180, 10)], .closed)
    static let p1: GLPolyShape = GLPolyShape([.init(100, 100), .init(100, 200), .init(200, 200), .init(200, 100)], .closed)
    static let p2: GLPolyShape = GLPolyShape([.init(100, 100), .init(100, 200), .init(200, 200), .init(200, 100)], .closed)
    
}
