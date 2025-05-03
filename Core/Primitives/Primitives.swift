import SwiftUI

struct Quadlet<Of> { 
    let i0, i1, i2, i3: Of
    init(_ inAll: Of) { i0 = inAll; i1 = inAll; i2 = inAll; i3 = inAll }
    init(_ in0: Of, _ in1: Of, _ in2: Of, _ in3: Of) { i0 = in0; i1 = in1; i2 = in2; i3 = in3 }
}
struct Triplet<Of> { 
    let i0, i1, i2: Of
    init(_ inAll: Of) { i0 = inAll; i1 = inAll; i2 = inAll }
    init(_ in0: Of, _ in1: Of, _ in2: Of) { i0 = in0; i1 = in1; i2 = in2 }
}
struct Duplet<Of> { 
    let i0, i1: Of     
    init(_ inAll: Of) { i0 = inAll; i1 = inAll }
    init(_ in0: Of, _ in1: Of) { i0 = in0; i1 = in1 }
}

typealias Point = Int
typealias Line = Duplet<Int>
typealias Triangle = Triplet<Int>
typealias Quad = Quadlet<Int>

typealias Point3f = GLFloat3
typealias Line3f = Duplet<GLFloat3>
typealias Triangle3f = Triplet<GLFloat3>
typealias Quad3f = Quadlet<GLFloat3>


extension Point {
    func append(_ to: inout [Int]) { to.append(self) }
}
extension Line {
    init(startIdx: Int) { self.i0 = startIdx; self.i1 = startIdx+1 }
    func append(_ to: inout [Int]) { to.append(self) }
}
extension Triangle {
    init(startIdx: Int) { self.i0 = startIdx; self.i1 = startIdx+1; self.i2 = startIdx+2 }
    func append(_ to: inout [Int]) { to.append(self) }
}
// === Quad ===
extension Quad {
    init(startIdx: Int) { self.i0 = startIdx; self.i1 = startIdx+1; self.i2 = startIdx+2; self.i3 = startIdx+3 }
    func append(_ to: inout [Int]) { to.append(self) }
}

// === Array of Int ===
extension Array where Element == Int {
    // mutating func append(_ pt: Point) { self.append(pt) }
    mutating func append(_ line: Line) { self.append(contentsOf: [line.i0, line.i1]) }
    mutating func append(_ tri: Triangle) { self.append(contentsOf: [tri.i0, tri.i1, tri.i2]) }
    mutating func append(_ quad: Quad) { self.append(contentsOf: [quad.i0, quad.i1, quad.i2, quad.i3]) }
}
