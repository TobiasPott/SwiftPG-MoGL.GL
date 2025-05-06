import SwiftUI

struct FixedTransform: Transformation, Codable {
    // === Members ===
    let _location: Vector3 
    let _rotation: Quaternion
    let _scale: Vector3
    let _pivot: Vector3? 
    
    // === Properties === 
    var location: Vector3 { get { return _location } } 
    var rotation: Quaternion { get { return _rotation } } 
    var x: CGFloat { get { return (_location.x) } }
    var y: CGFloat { get { return (_location.y) } }
    var z: CGFloat { get { return (_location.z) } }
    var scale: Vector3 { get { return _scale } }
    var pivot: Vector3 { 
        get { return _pivot ?? .init(location.x, location.y, z) } 
    }
    var useCustomPivot: Bool { return _pivot != nil }
    
    // === Ctors ===
    init(_location: Vector3, _a: TFloat, _t: TFloat, _scale: Vector3, _pivot: Vector3?) {
        self._location = _location;
        self._rotation = Quaternion(angle: _a, axis: .yAxis)
        self._scale = _scale; self._pivot = _pivot
    }
    
    private enum CodingKeys : String, CodingKey {
        case _location, _rotation, _scale, _pivot
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: ._location)
        try container.encode(rotation, forKey: ._rotation)
        try container.encode(scale, forKey: ._scale)
        if let piv = _pivot {
            try container.encode(piv, forKey: ._pivot)
        }
    }
    
}
