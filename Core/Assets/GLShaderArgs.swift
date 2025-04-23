import SwiftUI

struct GLShaderArgs { 
    // === Members ===
    private var _args: [Shader.Argument]
    
    // === Properties ===    
    var args: [Shader.Argument] { get { return _args } }
    var count: Int { get { return _args.count } }
    
    // === Indexer ===
    subscript(index: Int) -> Shader.Argument {
        get { _args[index] }
        set { _args[index] = newValue }
    }
    
    // === Ctors ===
    init (count: Int) {
        // reserve expected number of entries but with random/invalid data for any use case
        self._args = Array(repeating: .float(0.0), count: count)
    }
    init (args: [Shader.Argument]) { self._args = args }
    
    
    // === Functions ===
    mutating func ensure(_ count: Int) {
        let diff = count - _args.count
        if diff > 0 {
            for _ in 0..<diff { _args.append(.float(0.0)) }
        }
    }
    static func uniform(_ args: [GLShaderArgs]) -> [Shader.Argument] {
        var result: [Shader.Argument] = []
        for arg in args {
            result.append(contentsOf: arg.args)
        }
        return result
    }
}
