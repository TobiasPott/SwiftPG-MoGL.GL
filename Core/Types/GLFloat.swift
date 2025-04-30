import SwiftUI

enum Channel: Int, RawRepresentable {
    case x = 0, y = 1, z = 2, w = 3
}

typealias GLFloat2 = CGPoint
// ToDo: Consider adding subscript with channels to make 'generalised' functions more easy to code (based on index)

struct GLFloat3: Codable, Animatable, VectorArithmetic {
    // === Static Members ===
    static var zero: Self { get{ Self.init() } }
    static let one: Self = .init(1, 1, 1)
    static let right: Self = .init(1, 0, 0)
    static let forward: Self = .init(0, 1, 0)
    static let up: Self = .init(0, 0, 1)
    
    static let gravity: Self = .init(0, 0, -9.81)
    
    // === Members ===
    private var channels: [CGFloat] = [0.0, 0.0, 0.0]
    
    // === Properties === 
    var x: CGFloat { get { return self[0] } set { self[0] = newValue } }
    var y: CGFloat { get { return self[1] } set { self[1] = newValue } }
    var z: CGFloat { get { return self[2] } set { self[2] = newValue } }
    
    var xy: CGPoint { get { return .init(x: x, y: y) } }
    var magnitudeSquared: Double { get { return (x * x) + (y * y) + (z * z) } }
    var magnitude: Double { get { return sqrt(magnitudeSquared) } }
    
    
    // === Indexer ===
    subscript(index: Int) -> CGFloat {
        get { channels[index] }
        set { channels[index] = newValue }
    }
    
    
    // === Ctors ===
    init() { }
    init(_ x: any BinaryFloatingPoint, _ y: any BinaryFloatingPoint, _ z: any BinaryFloatingPoint) {
        self.x = CGFloat(x); self.y = CGFloat(y); self.z = CGFloat(z)
    }
    init(x: any BinaryFloatingPoint) { self.x = CGFloat(x); self.y = 0; self.z = 0 }
    init(y: any BinaryFloatingPoint) { self.x = 0; self.y = CGFloat(y); self.z = 0 }
    init(z: any BinaryFloatingPoint) { self.x = 0; self.y = 0; self.z = CGFloat(z) }
    // integer ctors
    init(_ x: any BinaryInteger, _ y: any BinaryInteger, _ z: any BinaryInteger) {
        self.x = CGFloat(x); self.y = CGFloat(y); self.z = CGFloat(z)
    }
    init(x: any BinaryInteger) { self.x = CGFloat(x); self.y = 0; self.z = 0 }
    init(y: any BinaryInteger) { self.x = 0; self.y = CGFloat(y); self.z = 0 }
    init(z: any BinaryInteger) { self.x = 0; self.y = 0; self.z = CGFloat(z) }
    
    
    // === Functions ===
    func normalized() -> GLFloat3 {
        let length = self.magnitude
        if magnitude != 0 {
            return .init(x / length, y / length, z / length)
        } else { return self }
    }
    mutating func normalize() {
        let length = self.magnitude
        if magnitude != 0 {
            self.x /= length
            self.y /= length
            self.z /= length
        }
    }
    
    
    static prefix func -(_ val: GLFloat3) -> GLFloat3 { return GLFloat3(-val.x, -val.y, -val.z) }
    
    // === Static Functions === 
    static func encodeToJson(_ value: GLFloat3) -> Data {
        if let encoded = try? JSONEncoder().encode(value) { return encoded }
        return Data()
    }
    static func decodeFromJson(_ data: Data) -> GLFloat3 {
        if let decodedValue = try? JSONDecoder().decode(GLFloat3.self, from: data) {
            return decodedValue
        }
        return .zero
    }
    
    static func cross(_ lhs: GLFloat3, _ rhs: GLFloat3) -> GLFloat3 {
        return GLFloat3(lhs.y * rhs.z - lhs.z * rhs.y,
                        lhs.z * rhs.x - lhs.x * rhs.z,
                        lhs.x * rhs.y - lhs.y * rhs.x)
    }
}

extension GLFloat3 {
    static func +(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(lh.x + rh.x, lh.y + rh.y, lh.z + rh.z) }
    static func -(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(lh.x - rh.x, lh.y - rh.y, lh.z - rh.z) }
    static func *(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(lh.x * rh.x, lh.y * rh.y, lh.z * rh.z) }
    static func /(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(lh.x / rh.x, lh.y / rh.y, lh.z / rh.z) }
    
    static func +(lh: GLFloat3, rh: CGFloat) -> GLFloat3 { return .init(lh.x + rh, lh.y + rh, lh.z + rh) }
    static func -(lh: GLFloat3, rh: CGFloat) -> GLFloat3 { return .init(lh.x - rh, lh.y - rh, lh.z - rh) }
    static func *(lh: GLFloat3, rh: CGFloat) -> GLFloat3 { return .init(lh.x * rh, lh.y * rh, lh.z * rh) }
    static func /(lh: GLFloat3, rh: CGFloat) -> GLFloat3 { return .init(lh.x / rh, lh.y / rh, lh.z / rh) }
    
    // 
    static func += (lhs: inout GLFloat3, rhs: GLFloat3) { lhs = lhs + rhs }
    static func -= (lhs: inout GLFloat3, rhs: GLFloat3) { lhs = lhs - rhs }
    static func == (lhs: GLFloat3, rhs: GLFloat3) -> Bool { 
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    mutating func scale(by rhs: Double) {
        self.x *= rhs; self.y *= rhs; self.z *= rhs;
    }
}

extension [GLFloat3] {    
    func greater(_ channel: Channel, _ than: CGFloat) -> Bool {
        for el in self { if el[channel.rawValue] <= than { return false } }
        return true
    }
    func less(_ channel: Channel, _ than: CGFloat) -> Bool {
        // inverted compare, returns if any is greater or equal 
        for el in self { if el[channel.rawValue] >= than { return false } }
        return true
    }
}
