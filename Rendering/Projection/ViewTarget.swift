import SwiftUI

protocol ViewTarget: AnyObject {
    var transform: Transform { get }
    var fov: CGFloat { get }
    var nearClip: CGFloat { get }
    var farClip: CGFloat { get }
    var viewport: CGRect { get }
}
extension ViewTarget {
    var aspect: CGFloat { get { return viewport.width / viewport.height } }
    var w2: CGFloat { get { return (viewport.width / 2) } }
    var h2: CGFloat { get { return (viewport.height / 2) } }
    var screenCenter: Vector2 { get { return (viewport.size / 2).v2 } }
}
