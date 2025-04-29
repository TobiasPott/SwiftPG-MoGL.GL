import SwiftUI

enum GLBufferTarget {
    case back, front
}

class GLPathBuffer {
    // === Members ===
    var back: Path = Path()
    private var front: Path = Path()
    private var target: GLBufferTarget = .back
    
    // === Functions ===
    func swap() {
        let tmp = front
        front = back
        back = tmp
    }
    func clear() {
        back = Path()
    }
    func flush(_ targets: [GLBufferTarget] = [.back, .front]) {
        if targets.contains(.back) { back = Path() }
        if targets.contains(.front) { front = Path() }
    }
    func setTarget(_ newTarget: GLBufferTarget) { self.target = newTarget}
    func getBuffer(_ forTarget: GLBufferTarget? = nil) -> Path {
        if .back == (forTarget ?? target) { return back }
        else { return front }
    }
    
}
