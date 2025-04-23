import SwiftUI

struct GLFloat3: Codable, Animatable, VectorArithmetic {
    // === Static Members ===
    static var zero: Self { get{ Self.init() } }
    static let one: Self = .init(x: 1, y: 1, z: 1)
    static let gravity: Self = .init(x: 0, y: 0, z: -9.81)
    
    // === Members ===     
    var x, y, z: CGFloat
    
    // === Properties === 
    var xy: CGPoint { get { return .init(x: x, y: y) } }
    var magnitudeSquared: Double{ get { return (x * x) + (y * y) + (z * z) } }
    
    // === Ctors ===
    init(){
        self.x = 0; self.y = 0; self.z = 0
    }
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x; self.y = y; self.z = z
    }
    init(x: CGFloat) { self.x = x; self.y = 0; self.z = 0 }    
    init(y: CGFloat) { self.x = 0; self.y = y; self.z = 0 }
    init(z: CGFloat) { self.x = 0; self.y = 0; self.z = z }
    
    // === Functions ===
    static prefix func -(_ val: GLFloat3) -> GLFloat3 { return GLFloat3(x: -val.x, y: -val.y, z: -val.z) }
    
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
}

extension GLFloat3 {
    static func +(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(x: lh.x + rh.x, y: lh.y + rh.y, z: lh.z + rh.z) }
    static func -(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(x: lh.x - rh.x, y: lh.y - rh.y, z: lh.z - rh.z) }
    static func *(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(x: lh.x * rh.x, y: lh.y * rh.y, z: lh.z * rh.z) }
    static func /(lh: GLFloat3, rh: GLFloat3) -> GLFloat3 { return .init(x: lh.x / rh.x, y: lh.y / rh.y, z: lh.z / rh.z) }
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
