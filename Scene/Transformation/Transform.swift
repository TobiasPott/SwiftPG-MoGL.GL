import SwiftUI

class Transform: Transformation, ObservableObject, Codable {
    static let AnglePrecision: Int = 360
    static let AnglePrecisionSafeFactor: Int = AnglePrecision * 32
    
    static let identity: Transform = .init(_location: .zero, _a: 0, _t: 0)
    
    // === Events === 
    let changed: Event<Void> = Event<Void>()    
    
    // === Members === 
    @Published private var _location: Vector3 = .init(0, -100, 0.0)
    @Published private var _rotation: Quaternion = .init(angle: 0, axis: Vector3.yAxis)
    @Published private var _a: CGFloat = .zero
    @Published private var _t: CGFloat = .zero
    @Published private var _scale: Vector3 = .one
    @Published private var _pivot: Vector3? = nil // scale/rotate pivot 
    
    // === Properties === 
    var location: Vector3 { get { return _location } } 
    var rotation: Quaternion { get { return _rotation } } 
    var x: CGFloat { get { return (_location.x) } set { _location.x = (newValue) } }
    var y: CGFloat { get { return (_location.y) } set { _location.y = (newValue) } }
    var z: CGFloat { get { return (_location.z) } set { _location.z = (newValue) } }
    var a: CGFloat { 
        get { return _a } 
        set { _a = MoGLMath.safeAngle(newValue, rangeMax: CGFloat(Transform.AnglePrecision), safeGuard: CGFloat(Transform.AnglePrecisionSafeFactor)) 
            _rotation = Quaternion(angle: _a, axis: Vector3.yAxis)
        }
    }
    var t: CGFloat { 
        get { return _t } 
        set { _t = newValue } // MoGLMath.safeAngle(newValue, precision: Transform.LookPrecision, safeFactor: Transform.LookPrecisionSafeFactor) }
    }
    var scale: Vector3 { get { return _scale } set { _scale = newValue } }
    var pivot: Vector3 { 
        get { return _pivot ?? Vector3(location.x, location.y, z) } 
    }
    var useCustomPivot: Bool { return _pivot != nil }
    var forward: Vector3 { 
        let rotFwd = _rotation.rot(Vector3.zAxis)
//                print("RotFwd: \(rotFwd) \(_rotation)")
        return rotFwd
    }
    
    func setPivot(newValue: Vector3?) { _pivot = newValue }
    
    // === Ctors === 
    convenience init() {
        self.init(_location: .zero, _a: 0, _t: 0)
    }
    init(_location: Vector3, _a: CGFloat, _t: CGFloat) {
        self._location = _location; self._a = _a; self._t = _t
        self._rotation = Quaternion(angle: _a, axis: .yAxis)
    }
    required init(_location: Vector3, _a: CGFloat, _t: CGFloat, _scale: Vector3, _pivot: Vector3?) {
        self._location = _location; self._a = _a; self._t = _t
        self._rotation = Quaternion(angle: _a, axis: .yAxis)
        self._scale = _scale; self._pivot = _pivot
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // decode individual members from container
        self._location = try container.decode(Vector3.self, forKey: ._location)
        self._rotation = try container.decode(Quaternion.self, forKey: ._rotation)
        self._a = try container.decode(CGFloat.self, forKey: ._a)
        self._t = try container.decode(CGFloat.self, forKey: ._t)
        self._scale = try container.decode(Vector3.self, forKey: ._scale)
        self._pivot = try container.decodeIfPresent(Vector3.self, forKey: ._pivot)
    }
    
    // === Functions ===
    
    // PRIORITY
    // ToDo: change axis orientation so y axis is considered up (swap y and z code)
    //        change moveRelative functions to expect Vector3 input instead of CGPoint 
    //        (apply to all other functions and protocol if needed)
    //         remove Int argument variants 
    func moveRelativeBy(_ deltaXY: CGPoint) { self.moveRelativeBy(deltaXY.x, deltaXY.y, 0) }
    func moveRelativeBy(_ deltaX: CGFloat = 0, _ deltaY: CGFloat = 0, _ deltaZ: CGFloat = 0) {
        if deltaX != 0 { 
            self._location.x = self._location.x + MoGLMath.sin(self.a + 90) * deltaX
            self._location.y = self._location.y + MoGLMath.cos(self.a + 90) * deltaX
        }
        if deltaY != 0 { 
            self._location.x = self._location.x + MoGLMath.sin(self.a) * deltaY
            self._location.y = self._location.y + MoGLMath.cos(self.a) * deltaY 
        }
        if deltaZ != 0 { self._location.z = self._location.z + Int(deltaZ) }
        self.onChanged()
    }
    func moveRelativeBy(_ deltaX: Int = 0, _ deltaY: Int = 0, _ deltaZ: Int = 0) {
        self.moveRelativeBy(CGFloat(deltaX), CGFloat(deltaY), CGFloat(deltaZ))
    }
    func moveBy(_ deltaX: CGFloat = 0, _ deltaY: CGFloat = 0, _ deltaZ: CGFloat = 0) {
        if deltaX != 0 { self._location.x = self._location.x + deltaX }
        if deltaY != 0 { self._location.y = self._location.y + deltaY }
        
        if deltaZ != 0 { self._location.z = self._location.z + Int(deltaZ) }
        self.onChanged()
    }
    func moveBy(_ deltaX: Int = 0, _ deltaY: Int = 0, _ deltaZ: Int = 0) {
        self.moveBy(CGFloat(deltaX), CGFloat(deltaY), CGFloat(deltaZ))
    }
    func move(_ toX: Int? = nil, _ toY: Int? = nil, _ toZ: CGFloat? = nil) {
        if let x = toX { self._location.x = CGFloat(x) }
        if let y = toY { self._location.y = CGFloat(y) }
        
        if let z = toZ { self._location.z = (z) }
        self.onChanged()
    }
    
    
    func tilt(_ toT: CGFloat) { 
        self._t = toT 
        self.onChanged()
    }
    func tiltBy(_ deltaT: CGFloat) { 
        if deltaT != 0 { self._t = MoGLMath.safeAngle(_t + deltaT) } 
        self.onChanged()    
    }
    func rotate(_ toA: CGFloat) { 
        self._a = toA 
        _rotation = Quaternion(angle: toA, axis: .yAxis)
        self.onChanged()
    }
    func rotateBy(_ deltaA: CGFloat) { 
        if deltaA != 0 {
            self._a = MoGLMath.safeAngle(_a + deltaA)
            _rotation = Quaternion(angle: _a, axis: .yAxis)
        } 
        self.onChanged()    
    }
    func rotateBy(_ deltaA: Int) { 
        self.rotateBy(CGFloat(deltaA))
    }
    
    // set/alter all transform members
    func set(_ other: Transform) {
        self._location = other._location
        self._rotation = other._rotation
        self._a = other._a
        self._t = other._t
        self._scale = other._scale
        self._pivot = other._pivot
        self.onChanged()
    }
    func toIdentity() -> Self { 
        set(.identity)
        return self
    }
    
    private func onChanged() {
        self.changed.invoke(data: ())
    }
    
    
    private enum CodingKeys : String, CodingKey {
        case _location, _rotation, _a, _t, _scale, _pivot
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: ._location)
        try container.encode(rotation, forKey: ._rotation)
        try container.encode(a, forKey: ._a)
        try container.encode(t, forKey: ._t)
        try container.encode(scale, forKey: ._scale)
        if let piv = _pivot {
            try container.encode(piv, forKey: ._pivot)
        }
    }
    
}
