import SwiftUI

protocol Transformer {
    // === Properties ===
    var winding: GLWinding { get }
    
    // === Functions ===
    func getToScreen(_ index: Int) -> CGPoint
    func getToView(_ index: Int) -> GLFloat3
    // ToDo: change get/setCamera to get/setViewTarget
    func getViewTarget() -> ViewTarget?
    func setViewTarget(_ newViewTarget: ViewTarget?)
    
    // projection to different spaces
    func projectToView(_ pb1: GLFloat3, _ pb2: GLFloat3, _ pt1: GLFloat3, _ pt2: GLFloat3)
    func projectToScreen() -> Bool
    
    // helper/analysis functions
    func distanceTo3D(_ location: GLFloat3) -> CGFloat
}
