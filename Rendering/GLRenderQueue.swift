import SwiftUI

class GLRenderQueue: RDBase {
    // ToDo: Consider introducing a max capacity of 65k (UShort16.max)
    //    will amount to 512kByte of memory use for the queue alone
    //        maybe reduce it even as 512k render data behind the queue seems quite a lot
    //         Base RenderData =    44  44    7 x 4 bytes + 16 bytes (metadata)
    //            Add Edge3D        56  16    4 x 4 bytes
    //            Add Cap           60  20    1 x 4 bytes + 4 x 4 bytes (points)
    // === Members ===
    private var data: [RDBase] = []
    var sortFunc: (_ lh: RDBase, _ rh: RDBase) -> Bool = RDBase.sortByDistance 
    
    // === Ctors ===
    init(_ rendererData: GLRenderDataBuffer) {
        rendererData.enqueue(&data, true, false)
    }
    
    // === Functions ===
    func sortData() {
        data.bubbleSort(by: sortFunc)
    }
    
    override func renderData(_ gl: MoGL, matFunc: (Int) -> SurfaceMaterial) {
        if self.isCulled{ return }
        for rd in data {
//            print("Dist: \(rd.d) \(rd.dz) \(rd.self)")
            rd.renderData(gl, matFunc: matFunc)
        }
    }
    
}
