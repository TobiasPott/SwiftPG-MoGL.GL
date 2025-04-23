import SwiftUI

protocol Transformation: Codable {
    
    // === Properties ===
    var location: CGPoint { get } 
    var x: Int { get }
    var y: Int { get }
    var z: Int { get }
    var a: Int { get }
    var t: Int { get }
    var scale: GLFloat3 { get }
    var pivot: GLFloat3 { get } 
    var useCustomPivot: Bool { get }
    
    // === Ctors ===
    init(_location: CGPoint, _z: Int, _a: Int, _t: Int, _scale: GLFloat3, _pivot: GLFloat3?)
}

// ToDo: add function to add transform (transform transforms)
//        scale, rotate & offset location and z, 
//        add angle and tilt, 
//        multiply scale
//        keep pivot
extension Transformation {
    
    func xForm(_ other: Transformation) { } // transform in-place in 'self'
    static func xForm<T: Transformation>(_ lh: Transformation, _ rh: Transformation) -> T {
        // transform left by right (apply right transformations to left's members where possible)
        // scale first
        // rotate
        // translate last
        
        return Transform() as! T 
    } // transform two into one ?FixedTransform? (may add 'init' to protocol and allow generic function to provide type to combine the inputs into
    
    
    func xformTranslate(_ zEdge: ZEdge) -> ZEdge {
        return ZEdge(zEdge.min + self.z, zEdge.height)
    }
    func xformRotate(_ zEdge: ZEdge) -> ZEdge {
        print("xFormRotate(ZEgde) does nothing and is just for code symmetry, don't use unless overriden!")
        return zEdge
    }
    func xformScale(_ zEdge: ZEdge) -> ZEdge {
        let zPivot = Int(self.pivot.z)
        let zMin: Int = Int((zEdge.min - zPivot) * scale.z) + zPivot
        let zMax: Int = Int((zEdge.max - zPivot) * scale.z) + zPivot
        return ZEdge(zMin, zMax)
    }
    func xform(_ zEdge: ZEdge) -> ZEdge {
        // no rotation for z edges for now
        return xformTranslate(xformScale(zEdge))
    }
    
    
    func xformTranslate(_ point: CGPoint) -> CGPoint { return point + self.location }
    func xformRotate(_ point: CGPoint) -> CGPoint {
        if self.a != 0 { return point.rotate(self.a, self.pivot.xy) }
        return point
    }
    func xformScale(_ point: CGPoint) -> CGPoint {
        if scale.x != 1.0 || scale.y != 1.0 { return point.scale(self.scale.xy, self.pivot.xy) }
        return point
    }
    func xform(_ point: CGPoint) -> CGPoint {
        let scaled = point.scale(self.scale.xy, self.pivot.xy)
        let rotated = scaled.rotate(self.a, self.pivot.xy)
        return rotated + self.location
    }
    
    
    func xformTranslate(_ edge: Edge2D) -> Edge2D { 
        return .init(edge.p1 + self.location, edge.p2 + self.location)
    }
    func xformRotate(_ edge: Edge2D) -> Edge2D {
        if self.a != 0 {
            return .init(edge.p1.rotate(self.a, self.pivot.xy),
                         edge.p2.rotate(self.a, self.pivot.xy))
        }
        return edge
    }
    func xformScale(_ edge: Edge2D) -> Edge2D {
        if scale.x != 1.0 || scale.y != 1.0 {
            return .init(edge.p1.scale(self.scale.xy, self.pivot.xy),
                         edge.p2.scale(self.scale.xy, self.pivot.xy))
        }
        return edge
    }
    func xform(_ edge: Edge2D) -> Edge2D {
        let scaled = xformScale(edge)
        let rotated = xformScale(scaled)
        return xformTranslate(rotated)
    }
}
