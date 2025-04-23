import SwiftUI

enum GLTextureWrap {
    case `repeat`, mirror, clamp_to_edge, clamp_to_border
}

struct GLSampler {
    
    private static let BORDER: Int = -1
    static let white: GLSampler = GLSampler(2, 2, solid: Int.max)
    static let black: GLSampler = GLSampler(2, 2, solid: 255)
    static let gray: GLSampler = GLSampler(2, 2, solid: Int(127, 127, 127))
    
    
    let w, h: Int
    let wrapX, wrapY: GLTextureWrap
    let border: Int
    var mipMaps: [GLMipLevel]
    
    // create a solid color single mip sampler
    init(_ image: CGImage, border: Int) {
        self.w = Int(image.width); self.h = Int(image.height);
        self.border = border
        self.wrapX = .clamp_to_edge
        self.wrapY = .clamp_to_edge
        self.mipMaps = [GLMipLevel(data: image.getPixelsRGBA())]
    }
    init(_ w: Int, _ h: Int, solid: Int) {
        self.w = w
        self.h = h
        self.border = solid
        self.wrapX = .clamp_to_edge
        self.wrapY = .clamp_to_edge
        self.mipMaps = [GLMipLevel(data: Array(repeating: solid, count: w * h))]
    }
    init(_ w: Int, _ h: Int, border: Int, level0: [Int]) {
        self.w = w
        self.h = h
        self.border = border
        self.wrapX = .clamp_to_edge
        self.wrapY = .clamp_to_edge
        self.mipMaps = [GLMipLevel(data: level0)]
    }
    
    func sample(_ x: CGFloat, _ y: CGFloat, mip: Int = 0) -> Int {
        return sample(Int(x * w), Int(y * h), mip: mip)
    }
    func sample(_ x: Int, _ y: Int, mip: Int = 0) -> Int {
        // safe guard mip index against number of mipmaps 
        let mipIdx = mip < 0 ? 0 : mip >= mipMaps.count ? mipMaps.count-1 : mip
        let mX = mipCoord(wrapCoord(x, min: 0, max: w, wrap: wrapX), mip: mipIdx)
        let mY = mipCoord(wrapCoord(y, min: 0, max: h, wrap: wrapY), mip: mipIdx)
        // check if mip level exists, otherwise sample base level zero
        return sampleMip(mipX: mX, 
                         mipY: mY, 
                         mip: mipIdx)
    }
    private func wrapCoord(_ c: Int, min: Int, max: Int, wrap: GLTextureWrap) -> Int {
        // should use internal wrap member to modify the given coordinate
        //    return should be safe in the resolution range
        switch wrap {
        case .clamp_to_edge: 
            if c >= max { return max-1 }
            if c < 0 { return 0 }
            break
        case .clamp_to_border: 
            if c >= max { return GLSampler.BORDER }
            if c < 0 { return GLSampler.BORDER }
            break
        case .repeat, .mirror:
            break
        }
        return c
    }
    private func mipCoord(_ c: Int, mip: Int) -> Int {
        if c == GLSampler.BORDER { return GLSampler.BORDER } // check border
        if mip > 0 {
            let mipDivisor = Int(pow(Double(2), Double(mip)))
            return c / mipDivisor
            // should map a level 0 coordinate to an appropriate mip level coordinate (divide)
        }
        return c
    }
    private func sampleMip(mipX: Int, mipY: Int, mip: Int) -> Int {
        let c = mipY + mipX * h
        //        print("\(mipX), \(mipY) on \(mip) = \(Color(uiColor: mipMaps[mip].data[c]))")
        return mipMaps[mip].get(idx: c)
    }
}
