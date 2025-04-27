import SwiftUI

//https://gamedev.stackexchange.com/questions/159434/how-to-convert-3d-coordinates-to-2d-isometric-coordinates
// projects zwo vertical edges onto x/y plane
class IsoProjection: TransformerStage, Projection {
    private static let defaultIsoScale: CGFloat = 1.75
    
    // === Members ===
    private var isoScale: CGFloat // cannot be zero (causes division by zero)
    // === Properties ===
    var winding: GLWinding { get { return (toView[1].x > toView[1].x) ? .ccw : .cw } }
    
    // === Ctors ===
    init(_ newResolution: CGFloat, isoScale: CGFloat = IsoProjection.defaultIsoScale) {
        self.isoScale = isoScale <= 0 ? Self.defaultIsoScale : isoScale
        super.init()
        self.resolution = newResolution.isZero ? 1.0 : newResolution
    }
    
    // === Functions ===
    // ToDo rework to compare camera against the GLFloat3 array
    func cullNear() -> Bool {
        if let vt = viewTarget { return toView.compactMap { i in i.z }.less(vt.nearClip) }
        return false
    }
    func cullFar() -> Bool {
        if let vt = viewTarget { return toView.compactMap { i in i.z }.greater(vt.farClip) }
        return false
    }
    func clipNear() -> Bool { return false }
    func clipFar() -> Bool { return false }
    
    func distanceTo3D(_ location: GLFloat3) -> CGFloat {
        let locViewMiddle = (toView[0] + toView[1]) / 2.0
        return (location - locViewMiddle).magnitude
    }
    
    func projectToView(_ pb1: GLFloat3, _ pb2: GLFloat3, _ pt1: GLFloat3, _ pt2: GLFloat3) {
        // ToDo: transfer from projectToView(CGPoint..)
    }
    func projectToView(_ p1: CGPoint, _ p2: CGPoint, ze1: ZEdge, ze2: ZEdge) {
        if let vt = self.viewTarget {
            let viewTfs = vt.transform
            let viewLoc = viewTfs.location
            let viewZ = (viewTfs.z)
            
            //offset bottom 2 points by player
            let nP1 = (p1).rotate(viewTfs.a, viewLoc * -1, cosine, sine)
            let nP2 = (p2).rotate(viewTfs.a, viewLoc * -1, cosine, sine)
            
            let x1: CGFloat = (((nP1.x) - viewTfs.x) / resolution)
            let y1: CGFloat = (((nP1.y) - viewTfs.y) / resolution)
            
            let x2: CGFloat = (((nP2.x) - viewTfs.x) / resolution)
            let y2: CGFloat = (((nP2.y) - viewTfs.y) / resolution)
            
            //view X position 
            let x = [x1, x2, x2, x1]
            //view Y position (depth)
            let y = [y1, y2, 
                     y2 + (CGFloat(ze2.height) / (isoScale)), 
                     y1 + (CGFloat(ze1.height) / (isoScale))]
            
            var z: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
            //view z position 
            z[3] = (ze1.min - viewZ + (y[3] / resolution)) 
            z[2] = (ze2.min - viewZ + (y[2] / resolution))
            z[1] = (ze2.max - viewZ + (y[1] / resolution))
            z[0] = (ze1.max - viewZ + (y[0] / resolution))
            
            self.toView[0] = .init(x[0], y[0], z[0])
            self.toView[1] = .init(x[1], y[1], z[1])
            self.toView[2] = .init(x[2], y[2], z[2])
            self.toView[3] = .init(x[3], y[3], z[3])
        }
    }
    
    func projectToScreen() -> Bool {
        if let vt = self.viewTarget {
            for i in 0..<toView.count {
                toScreen[i] = toView[i].xy + GLFloat2(vt.w2, 0/*vt.h2*/)
            }
        }
        
        return false
    }
}
