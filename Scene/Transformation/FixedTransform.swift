import SwiftUI

struct FixedTransform: Transformation, Codable {
    // === Members ===
    let _location: GLFloat3 
    let _a, _t: Int
    let _scale: GLFloat3
    let _pivot: GLFloat3? 
    
    // === Properties === 
    var location: GLFloat3 { get { return _location } } 
    var x: CGFloat { get { return (_location.x) } }
    var y: CGFloat { get { return (_location.y) } }
    var z: CGFloat { get { return (_location.z) } }
    var a: Int { get { return Int(_a) } }
    var t: Int { get { return _t } }
    var scale: GLFloat3 { get { return _scale } }
    var pivot: GLFloat3 { 
        get { return _pivot ?? .init(location.x, location.y, z) } 
    }
    var useCustomPivot: Bool { return _pivot != nil }
    
    // === Ctors ===
    init(_location: GLFloat3, _a: Int, _t: Int, _scale: GLFloat3, _pivot: GLFloat3?) {
        self._location = _location; self._a = _a; self._t = _t
        self._scale = _scale; self._pivot = _pivot
    }
    
    private enum CodingKeys : String, CodingKey {
        case _location, _a, _t, _scale, _pivot
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: ._location)
        try container.encode(a, forKey: ._a)
        try container.encode(t, forKey: ._t)
        try container.encode(scale, forKey: ._scale)
        if let piv = _pivot {
            try container.encode(piv, forKey: ._pivot)
        }
    }
        
}
