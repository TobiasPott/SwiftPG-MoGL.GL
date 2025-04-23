import SwiftUI

// ToDo: Cleanup Remark: This is project specific code and needs to be split 
//        Need to make generic functions where necessary
//split of as extensions and locate in a 'Resources/Assets' folder

struct GLTextures {
    static let cgMissing8: CGImage = (UIImage(named: "Missing8")!).cgImage!
    static let cgUVChecker: CGImage = (UIImage(named: "UVChecker8")!).cgImage!
    static let cgBBSample: CGImage = (UIImage(named: "SpriteSample_Billboard")!).cgImage!
    static let cgAtlas_Explosion: CGImage = (UIImage(named: "Atlas_Explosion")!).cgImage! 
}

struct GLAtlas {
    static let explosion: [CGImage] = makeAtlas(GLTextures.cgAtlas_Explosion, normalizedRects: CGRect.slice(x: 4, y: 4))
    
    
    static func makeAtlas(_ source: CGImage, normalizedRects: [CGRect]) -> [CGImage] {
        var results: [CGImage] = []
        for nR in normalizedRects {
            let rect = CGRect(x: nR.minX * source.width, y: nR.minY * source.height, width: nR.width * source.width, height: nR.height * source.height)
            results.append(source.cropping(to: rect)!) 
        }
        return results
    }
}



