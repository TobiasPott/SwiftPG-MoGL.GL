import SwiftUI

/** Protocol describing objects that can be displayed using MoGL **/
protocol Renderable {
    func update(camera: Camera)
    func draw(_ gl: MoGL, camera: Camera) 
}

class GLRenderer: ObservableObject, Renderable { 
    var renderData: GLRenderDataBuffer
    var queue: GLRenderQueue
    var materials: [SurfaceMaterial] = [.grayLit, .redLit, .blueLit, .checkerTextured]
    
    // === Ctors ===
    init(renderData: GLRenderDataBuffer) { 
        self.renderData = renderData
        queue = GLRenderQueue(renderData)
    }
    
    // === Functions ===
    private func getMaterial(_ mIdx: Int) -> SurfaceMaterial { return materials[mIdx % materials.count]}
    
    func update(camera: Camera) {
        // don't render if data is empty
        if renderData.isEmpty { return }
        camera.updateProjection()
        renderData.applyProjection(camera.projection)
        // sort queue and draw it
        queue.sortData()        
    }
    func draw(_ gl: MoGL, camera: Camera) {
        // don't render if data is empty
        if renderData.isEmpty { return }
        // ToDo: work out internalization of gl state changes per GLRendererData type
        // set gl state for the current renderer (maybe part of queue later on)
        gl.glLineWidth(2.0)
        queue.renderData(gl, matFunc: getMaterial)
    }
    
}
