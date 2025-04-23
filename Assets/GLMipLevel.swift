import SwiftUI

// ToDo: implement auto derive lower mipmap from existing mipmap
//        args: miplevel, source resolution
// ToDo: Ponder if I can build a access method for mipmap which abstracts access to the data, so I can map multiple mipLayers to the same base data
struct GLMipLevel {
    // === Members ===
    let data: [Int]
    
    // === Functions === 
    func get(idx: Int) -> Int { return data[idx] }
    
    func sub(inRect: CGRect, strideLength: Int) -> GLMipLevel {
        return sub(x: Int(inRect.minX), y: Int(inRect.minY), subWidth: Int(inRect.width), subHeight: Int(inRect.height), strideLength: strideLength)
    }
    func sub(x: Int, y: Int, subWidth: Int, subHeight: Int, strideLength: Int) -> GLMipLevel {
        var subData: [Int] = []
        for iX in x..<x+subWidth {
            let subStart = iX * strideLength + y
            for idx in subStart..<subStart+subHeight { subData.append(data[idx]) }
        }
        return GLMipLevel(data: subData)
    }
}
