import SwiftUI

protocol Culling {
    // clipping functions
    func clipNear() -> Bool
    func clipFar() -> Bool
    
    // culling functions
    func cullNear() -> Bool
    func cullFar() -> Bool
}

extension Culling {
    func cull(_ winding: GLWinding = GLWinding.ccw) -> Bool {
        return cullNear() || cullFar()
    }
}
