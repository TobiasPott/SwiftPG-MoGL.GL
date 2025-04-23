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
    func append(vertices: [CGPoint]) { _vertices.append(contentsOf: vertices) }
    func append(_ edgeData: Edge3DData, _ top: Bool = true) {
        //        print("\(edgeData.pt1) \(edgeData.pb1) -- \(edgeData.pt2) \(edgeData.pb2)")
        if top { // append top points
            _vertices.append(edgeData.pt1)
            _vertices.append(edgeData.pt2)            
        } else { // append bottom points
            _vertices.append(edgeData.pb1)
            _vertices.append(edgeData.pb2)
        }
    }
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
    
    
    func drawPrimtive(_ gl: MoGL, _ connect: Bool? = nil, _ close: Bool? = nil) {
        if !isEmpty { gl.glPolygon2f(self.vertices, connect ?? false, close ?? true) } 
    }
    
}
