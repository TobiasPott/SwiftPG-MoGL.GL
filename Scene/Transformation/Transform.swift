import SwiftUI

class Transform: Transformation, ObservableObject, Codable {
    static let AnglePrecision: Int = 360
    static let AnglePrecisionSafeFactor: Int = AnglePrecision * 32
    
    static let identity: Transform = .init(_location: .zero, _z: 0, _a: 0, _t: 0)
    
    // === Events === 
    let changed: Event<Void> = Event<Void>()    
    
    // === Members === 
    @Published private var _location: CGPoint = .init(0, -100) 
    @Published private var _z: CGFloat = -50.0
    @Published private var _a: Int = .zero
    @Published private var _t: Int = .zero
    @Published private var _scale: GLFloat3 = .one
    @Published private var _pivot: GLFloat3? = nil // scale/rotate pivot 
    
    // === Properties === 
    var location: CGPoint { get { return _location } } 
    var x: CGFloat { get { return (_location.x) } set { _location.x = (newValue) } }
    var y: CGFloat { get { return (_location.y) } set { _location.y = (newValue) } }
    var z: CGFloat { get { return (_z) } set { _z = (newValue) } }
    var a: Int { 
        get { return Int(_a) } 
        set { _a = MoGLMath.safeAngle(newValue, rangeMax: Transform.AnglePrecision, safeGuard: Transform.AnglePrecisionSafeFactor) }
    }
    var t: Int { 
        get { return _t } 
        set { _t = newValue } // MoGLMath.safeAngle(newValue, precision: Transform.LookPrecision, safeFactor: Transform.LookPrecisionSafeFactor) }
    }
    var scale: GLFloat3 { get { return _scale } set { _scale = newValue } }
    var pivot: GLFloat3 { 
        get { return _pivot ?? GLFloat3(location.x, location.y, z) } 
    }
    var useCustomPivot: Bool { return _pivot != nil }
    
    func setPivot(newValue: GLFloat3?) { _pivot = newValue }
    
    // === Ctors === 
    convenience init() {
        self.init(_location: .zero, _z: 0, _a: 0, _t: 0)
    }
    init(_location: CGPoint, _z: CGFloat, _a: Int, _t: Int) {
        self._location = _location; self._z = _z; self._a = _a; self._t = _t
    }
    required init(_location: CGPoint, _z: CGFloat, _a: Int, _t: Int, _scale: GLFloat3, _pivot: GLFloat3?) {
        self._location = _location; self._z = _z; self._a = _a; self._t = _t
        self._scale = _scale; self._pivot = _pivot
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // decode individual members from container
        self._location = try container.decode(CGPoint.self, forKey: ._location)
        self._z = try container.decode(CGFloat.self, forKey: ._z)
        self._a = try container.decode(Int.self, forKey: ._a)
        self._t = try container.decode(Int.self, forKey: ._t)
        self._scale = try container.decode(GLFloat3.self, forKey: ._scale)
        self._pivot = try container.decodeIfPresent(GLFloat3.self, forKey: ._pivot)
    }
    
    // === Functions === 
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
        if deltaZ != 0 { self._z = self._z + Int(deltaZ) }
        self.onChanged()
    }
    func moveRelativeBy(_ deltaX: Int = 0, _ deltaY: Int = 0, _ deltaZ: Int = 0) {
        self.moveRelativeBy(CGFloat(deltaX), CGFloat(deltaY), CGFloat(deltaZ))
    }
    func moveBy(_ deltaX: CGFloat = 0, _ deltaY: CGFloat = 0, _ deltaZ: CGFloat = 0) {
        if deltaX != 0 { self._location.x = self._location.x + deltaX }
        if deltaY != 0 { self._location.y = self._location.y + deltaY }
        
        if deltaZ != 0 { self._z = self._z + Int(deltaZ) }
        self.onChanged()
    }
    func moveBy(_ deltaX: Int = 0, _ deltaY: Int = 0, _ deltaZ: Int = 0) {
        self.moveBy(CGFloat(deltaX), CGFloat(deltaY), CGFloat(deltaZ))
    }
    func move(_ toX: Int? = nil, _ toY: Int? = nil, _ toZ: CGFloat? = nil) {
        if let x = toX { self._location.x = CGFloat(x) }
        if let y = toY { self._location.y = CGFloat(y) }
        
        if let z = toZ { self._z = (z) }
        self.onChanged()
    }
    
    
    func tilt(_ toT: Int) { 
        self._t = toT 
        self.onChanged()
    }
    func tiltBy(_ deltaT: Int) { 
        if deltaT != 0 { self._t = MoGLMath.safeAngle(_t + deltaT) } 
        self.onChanged()    
    }
    func rotate(_ toA: Int) { 
        self._a = toA 
        self.onChanged()
    }
    func rotateBy(_ deltaA: CGFloat) { 
        if deltaA != 0 { self._a = MoGLMath.safeAngle(_a + Int(deltaA)) } 
        self.onChanged()    
    }
    func rotateBy(_ deltaA: Int) { 
        self.rotateBy(CGFloat(deltaA))
    }
    
    // set/alter all transform members
    func set(_ other: Transform) {
        self._location = other._location
        self._z = other._z
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
