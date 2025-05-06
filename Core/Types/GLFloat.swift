import SwiftUI

enum Channel: Int, RawRepresentable {
    case x = 0, y = 1, z = 2, w = 3
}
//
//typealias GLFloat2 = CGPoint
//// ToDo: Consider adding subscript with channels to make 'generalised' functions more easy to code (based on index)
//extension GLFloat2: @retroactive CustomStringConvertible {
//    public var description: String {
//        return "(\(String(format: "%.3f", x)), \(String(format: "%.3f", y)))"
//    }
//} 

extension Vector2 {
    // === Static Members ===
    static var zero: Self { get { .init(0, 0) } }
    static let one: Self = .init(1, 1)
    static let right: Self = .init(1, 0)
    static let up: Self = .init(0, 1)
    
    // === Properties ===
    var cgPoint: CGPoint { get { return .init(x: x, y: y) } }
}

extension Vector3 {
    // === Static Members ===
    static var zero: Self { get{ Self.init() } }
    static let one: Self = .init(1, 1, 1)
    static let xAxis: Self = .init(1, 0, 0)
    static let yAxis: Self = .init(0, 1, 0)
    static let zAxis: Self = .init(0, 0, 1)
    
    // === Properties ===
    var xy: Vector2 { get { return .init(x: x, y: y) } }
}

extension CGPoint {
    var v2: Vector2 { get { return .init(x: x, y: y) } }
}
extension CGSize {
    var v2: Vector2 { get { return .init(x: width, y: height) } }
}
