import SwiftUI

// ToDo: Consider making Projection sth like 'blendable' so the 'output' can be blended between
// ToDo: Consider reducing the protocol signature
protocol Projection: Transformer, Culling {
    //    // === Properties ===
    
    //    // === Functions ===
    func projectToView(_ p1: Vector2, _ p2: Vector2, ze1: ZEdge, ze2: ZEdge)    
}
