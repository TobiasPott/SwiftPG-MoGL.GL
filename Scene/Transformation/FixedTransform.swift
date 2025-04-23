import SwiftUI

struct FixedTransform: Transformation, Codable {
    // === Members ===
    let _location: CGPoint 
    let _z, _a, _t: Int
    let _scale: GLFloat3
    let _pivot: GLFloat3? 
    
    // === Properties === 
    var location: CGPoint { get { return _location } } 
    var x: Int { get { return Int(_location.x) } }
    var y: Int { get { return Int(_location.y) } }
    var z: Int { get { return Int(_z) } }
    var a: Int { get { return Int(_a) } }
    var t: Int { get { return _t } }
    var scale: GLFloat3 { get { return _scale } }
    var pivot: GLFloat3 { 
        get { return _pivot ?? GLFloat3(x: location.x, y: location.y, z: CGFloat(z)) } 
    }
    var useCustomPivot: Bool { return _pivot != nil }
    
    // === Ctors ===
    init(_location: CGPoint, _z: Int, _a: Int, _t: Int, _scale: GLFloat3, _pivot: GLFloat3?) {
        self._location = _location; self._z = _z; self._a = _a; self._t = _t
        self._scale = _scale; self._pivot = _pivot
    }
    
    private enum CodingKeys : String, CodingKey {
        case _location, _z, _a, _t, _scale, _pivot
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: ._location)
        try container.encode(z, forKey: ._z)
        try container.encode(a, forKey: ._a)
        try container.encode(t, forKey: ._t)
        try container.encode(scale, forKey: ._scale)
        if let piv = _pivot {
            try container.encode(piv, forKey: ._pivot)
        }
    }
        
}
