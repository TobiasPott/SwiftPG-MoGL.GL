import SwiftUI

protocol GLRendererData {
    var isEmpty: Bool { get }
    func applyProjection(_ proj: Projection)
    func enqueue(_ to: inout [RDBase], _ replace: Bool, _ flatten: Bool)
}
