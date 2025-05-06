import SwiftUI

protocol Transformer {
    // === Properties ===
    var winding: GLWinding { get }
    
    // === Functions ===
    func getToScreen(_ index: Int) -> Vector2
    func getToView(_ index: Int) -> Vector3
    func getWinding() -> GLWinding
    func getViewTarget() -> ViewTarget?
    func setViewTarget(_ newViewTarget: ViewTarget?)
    
    // projection to different spaces
    func projectToView(_ pb1: Vector3, _ pb2: Vector3, _ pt1: Vector3, _ pt2: Vector3)
    func projectToScreen() -> Bool
    
    // helper/analysis functions
    func distanceTo3D(_ location: Vector3) -> CGFloat
    func distanceTo3D(_ index: Int, _ location: Vector3) -> CGFloat
}
