//import SwiftUI

enum PrimitiveType {
    case point, edge, tri, quad // ToDo: Consider adding poly/ngon for arbitrary numbered polygons (assuming 5 or more)
}
class GLIndexBuffer {
    // === Members ===
    var primitiveType: PrimitiveType = .quad
    var indices: [Int] = []
    
    // === Indexer ===
    subscript(index: Int) -> Int {
        get { indices[index] }
        set { indices[index] = newValue }
    }
    
}
