//import SwiftUI

class GLVertexBuffer {
    // === Members ===
    var vertices: [Vector3] = []
    var uvs0: BufferChannel<Vector2> = BufferChannel(fallback: .zero, initWith: nil)
    var normals: BufferChannel<Vector3> = BufferChannel(fallback: .yAxis, initWith: nil)
    var colors: BufferChannel<Int> = BufferChannel(fallback: .zero, initWith: nil)
    
    // === Functions ===
    subscript(vIdx: Int) -> Vector3 {
        get { vertices[vIdx] }
        set { vertices[vIdx] = newValue }
    }
    
    
}

class BufferChannel<GLType> {
    // === Members ===
    let fallback: GLType
    var data: [GLType]?
    
    // === Ctors ===
    init(fallback: GLType, initWith: [GLType]?) {
        self.fallback = fallback
        self.data = initWith
    }
    init(fallback: GLType, size: Int) {
        self.fallback = fallback
        self.data = size > 0 ? Array.init(repeating: fallback, count: size) : nil
    }
    
    // === Indexer ===
    subscript(idx: Int) -> GLType {
        get { return data?[idx] ?? fallback }
        set { if data != nil { data?[idx] = newValue } }
    }
    
    // === Functions ===
    func reserve(size: Int) {
        if (size > 0) { 
            let diff = size - (data?.count ?? 0)
            if diff > 0 {
                let toAppend = Array.init(repeating: fallback, count: size)
                if data == nil { data = toAppend }
                else { data?.append(contentsOf: toAppend) }
            } else if diff < 0 {
                data?.removeLast(diff)
            }
        } else { data = nil }
    }
}
