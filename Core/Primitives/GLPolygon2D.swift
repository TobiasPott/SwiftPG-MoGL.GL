import SwiftUI


class GLPolygon2D {
    private var _vertices: [Vector2] = []
    private var _fragments: [CGFloat] = []
    
    var isEmpty: Bool { get { return _vertices.isEmpty } }
    var vertices: [Vector2] { get { return _vertices } }
    var fragments: [CGFloat] { get { return _fragments } }
    
    var startIndex: Int { 0 }
    var endIndex: Int  { _vertices.count }
    var count: Int  { _vertices.count }
    
    subscript(index: Int) -> Vector2 {
        get { _vertices[index] }
        set { _vertices[index] = newValue } 
    }
    subscript(fragIdx: Int) -> CGFloat {
        get { _fragments[fragIdx] }
        set { _fragments[fragIdx] = newValue }
    }
    
    
    func set(at: Int, _ quadlet: Quadlet<Vector2>) { _vertices.set(at: at, quadlet) }
    func set(at: Int, _ quadlet: Quadlet<CGFloat>) { _fragments.set(at: at, quadlet) }
    
    func reserve(_ count: Int) { 
        if count >= _vertices.count { 
            _vertices.reserveCapacity(count)
            _fragments.reserveCapacity(count)
            for _ in _vertices.count..<_vertices.capacity {
                _vertices.append(.zero) 
                _fragments.append(.zero) 
            }  
        } 
    }
    func append(_ vertex: Vector2) { _vertices.append(vertex) }
    //    
    func append(contentsOf: any Sequence<Vector2>) { 
        let count = _vertices.count
        _vertices.append(contentsOf: contentsOf) 
        _fragments.append(contentsOf: Array.init(repeating: .zero, count: _vertices.count - count))
    }
    func removeAll() { 
        _vertices.removeAll(keepingCapacity: true)
        _fragments.removeAll(keepingCapacity: true)
    }
    func remove(_ at: Int) {
        _vertices.remove(at: at)
        _fragments.remove(at: at)
    }
    func removeSubrange(_ bounds: Range<Int>) {
        _vertices.removeSubrange(bounds)
        _fragments.removeSubrange(bounds)
    }
    func distinct() {
        //        let prevCount = _vertices.count
        var lastPoint = _vertices.first 
        var lastFrag = _fragments.first
        for i in stride(from: _vertices.count-1, to: 0, by: -1) {
            if lastPoint == _vertices[i], lastFrag == _fragments[i] {
                _vertices.remove(at: i)
                _fragments.remove(at: i)
            } else {
                lastPoint = _vertices[i]
                lastFrag = _fragments[i]
            }
        }
        //        print("distinct(\(prevCount) => \(_vertices.count))")
    }
    
    func swap(_ source: Int, _ dest: Int, _ stride: Int) {
        // unchecked implementation
        if stride > 1 {
            for i in 0..<stride {
                let tmpVtx = _vertices[source+i]
                _vertices[source+i] = _vertices[dest+i]
                _vertices[dest+i] = tmpVtx
                let tmpFrag = _fragments[source+i]
                _fragments[source+i] = _fragments[dest+i]
                _fragments[dest+i] = tmpFrag
            }
        } else if stride == 1 {
            let tmpVtx = _vertices[source]
            _vertices[source] = _vertices[dest]
            _vertices[dest] = tmpVtx
            let tmpFrag = _fragments[source]
            _fragments[source] = _fragments[dest]
            _fragments[dest] = tmpFrag
        }
    }
    
    
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

extension Array {
    mutating func set(at: Int, _ quadlet: Quadlet<Array.Element>) -> Void {
        self[at] = quadlet.i0
        self[at+1] = quadlet.i1
        self[at+2] = quadlet.i2
        self[at+3] = quadlet.i3
    }
}
