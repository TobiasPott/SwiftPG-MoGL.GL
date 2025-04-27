import SwiftUI

// ToDo: Consider making Projection sth like 'blendable' so the 'output' can be blended between
// ToDo: Consider reducing the protocol signature
protocol Projection {
    // === Properties ===
    // ToDo: convert winding into getWinding(idx) function with zero as default to allow winding query on all 'axes'
    var winding: GLWinding { get }
    
    // === Functions ===
    func getToScreen(_ index: Int) -> CGPoint
    func getToView(_ index: Int) -> GLFloat3
    // ToDo: change get/setCamera to get/setViewTarget
    func getCamera() -> Camera?
    func setCamera(_ newCamera: Camera?)
//    func setCamera(_ newCamera: ViewTarget?)
    
    // projection to different spaces
    func projectToView(_ pb1: GLFloat3, _ pb2: GLFloat3, _ pt1: GLFloat3, _ pt2: GLFloat3)
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge)    
    func projectToScreen() -> Bool
    
    // helper/analysis functions
    // ToDo: convert distanceTo to 3D distance (may be XY planar distance & Z distance, might also just be a 3D vector
    func distanceTo3D(_ location: GLFloat3) -> CGFloat
    
    // clipping functions
    func clipNear() -> Bool
    func clipFar() -> Bool
    // culling functions
    func cullNear() -> Bool
    func cullFar() -> Bool
}



extension Projection {
    func cull(_ winding: GLWinding = GLWinding.ccw) -> Bool {
        return cullNear() || cullFar()
    }
}
