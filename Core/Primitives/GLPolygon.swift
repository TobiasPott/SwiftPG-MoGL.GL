import SwiftUI


class GLPolygon: RandomAccessCollection {
    private var _vertices: [CGPoint] = []
    var fragment: CGFloat = 0
    
    var isEmpty: Bool { get { return _vertices.isEmpty } }
    var vertices: [CGPoint] { get { return _vertices } }
    
    var startIndex: Int { 0 }
    var endIndex: Int  { _vertices.count }
    var count: Int  { _vertices.count }
    
    subscript(index: Int) -> CGPoint {
        get { _vertices[index] }
        set { _vertices[index] = newValue}
    }
    
    func reserve(_ count: Int) { for _ in _vertices.count..<count { _vertices.append(.zero) } }
    func append(_ vertex: CGPoint) { _vertices.append(vertex) }
    
    func append(contentsOf: any Sequence<CGPoint>) { _vertices.append(contentsOf: contentsOf) }
    func append(vertices: [CGPoint]) { _vertices.append(contentsOf: vertices) }
    
    func removeAll() { _vertices.removeAll(keepingCapacity: true) }
    func removeAt(_ at: Int) { _vertices.remove(at: at) }
    func distinct() {
        //        let prevCount = _vertices.count
        var lastPoint = _vertices.first 
        for i in stride(from: _vertices.count-1, to: 0, by: -1) {
            if lastPoint == _vertices[i] {
                _vertices.remove(at: i)
            } else {
                lastPoint = _vertices[i]
            }
        }
        //        print("distinct(\(prevCount) => \(_vertices.count))")
    }
    func insertAt(_ vertex: CGPoint, _ at: Int) { _vertices.insert(vertex, at: at) }
    func insertAt(vertices: [CGPoint], _ at: Int) { _vertices.insert(contentsOf: vertices, at: at) }
    
    
    func drawPolygon(_ gl: MoGL, _ options: Flags = .none) {
        if !isEmpty { gl.glPolygon2f(self.vertices, options.contains(.connected), options.contains(.closed)) } 
    }
    
    
    
    struct Flags : OptionSet, Codable
    {
        let rawValue: UInt
        static let connected: Self = Flags(rawValue: 0x01)
        static let closed: Self = Flags(rawValue: 0x02)
        // predefined
        static let none: Self = []
        static let all: Self = [.connected, .closed]
    }
    
}
