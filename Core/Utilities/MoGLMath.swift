import SwiftUI
import Foundation

class MoGLMath {
    private static let DegRange: Int = 360
    private static let DegRangeSafe: Int = DegRange * 32
    private static let toRad: CGFloat = (1.0 / 180.0) * .pi
    
    
    private static let cosine: [CGFloat] = Array((0..<Transform.AnglePrecision).lazy.map {
        CoreGraphics.cos(CGFloat($0) * MoGLMath.toRad)
    })
    private static let sine: [CGFloat] = Array((0..<Transform.AnglePrecision).lazy.map {
        CoreGraphics.sin(CGFloat($0) * MoGLMath.toRad) 
    })
    
    // sine lookup from pre calculated precision array
    static func sin(_ angle: CGFloat) -> CGFloat { return sin(Int(angle)) }
    static func sin(_ angle: Int) -> CGFloat { 
        if angle >= MoGLMath.DegRange || angle < 0 {
            return sine[(angle + (MoGLMath.DegRangeSafe)) % MoGLMath.DegRange]       
        } else { return sine[angle] }
    }
    // cosine lookup from pre calculated precision array
    static func cos(_ angle: CGFloat) -> CGFloat { return cos(Int(angle)) }
    static func cos(_ angle: Int) -> CGFloat {
        if angle >= MoGLMath.DegRange || angle < 0 {
            return cosine[(angle + (MoGLMath.DegRangeSafe)) % MoGLMath.DegRange]
        } else { return cosine[angle] }
    }
    
    static func cosD(_ angle: CGFloat) -> CGFloat { 
        return CoreGraphics.cos(angle * MoGLMath.toRad) 
    }
    static func sinD(_ angle: CGFloat) -> CGFloat { 
        return CoreGraphics.sin(angle * MoGLMath.toRad) 
    }
    
    static func safeAngle(_ angle: Int) -> Int {
        return safeAngle(angle, rangeMax: MoGLMath.DegRange, safeGuard: MoGLMath.DegRangeSafe)
    }
    static func safeAngle(_ angle: Int, rangeMax: Int, safeGuard: Int) -> Int {
        if angle < 0 { return (angle + safeGuard) % rangeMax }
        else { return angle % rangeMax }
    }   
    static func angle360(_ p1: CGPoint, _ p2: CGPoint) -> Int {
        let nDir = (p2 - p1).normalized()
        if nDir != .zero {
            return (Int(atan2(nDir.y, nDir.x) * 180.0 / CGFloat.pi) + 180) % 360
        } else {
            return 0
        }
    } 
    static func dist2i(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) -> Int {
        let xPart = (x2 - x1) * (x2 - x1)
        let yPart = (y2 - y1) * (y2 - y1)
        return Int(sqrt(CGFloat(xPart + yPart)))
    }
    static func dist2f(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) -> CGFloat {
        let xPart = (x2 - x1) * (x2 - x1)
        let yPart = (y2 - y1) * (y2 - y1)
        return sqrt(xPart + yPart)
    }
    static func dist3i(_ x1: Int, _ y1: Int, _ z1: Int, _ x2: Int, _ y2: Int, _ z2: Int) -> Int {
        let xPart = (x2 - x1) * (x2 - x1)
        let yPart = (y2 - y1) * (y2 - y1)
        let zPart = (z2 - z1) * (z2 - z1)
        return Int(sqrt(CGFloat(xPart + yPart + zPart)))
    }
    static func dist3f(_ x1: CGFloat, _ y1: CGFloat, _ z1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ z2: CGFloat) -> CGFloat {
        let xPart = (x2 - x1) * (x2 - x1)
        let yPart = (y2 - y1) * (y2 - y1)
        let zPart = (z2 - z1) * (z2 - z1)
        return sqrt(xPart + yPart + zPart)
    }
    
    static func clipToViewport(x1: inout Int, y1: inout Int, _ viewport: CGRect) {
        if y1 < Int(viewport.minY) { y1 = Int(viewport.minY + 1) }
        if x1 < Int(viewport.minX) { x1 = Int(viewport.minX + 1) }
        if y1 > Int(viewport.maxY) { y1 = Int(viewport.maxY - 1) }
        if x1 > Int(viewport.maxX) { x1 = Int(viewport.maxX - 1) }
    }
    
}
