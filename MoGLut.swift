import SwiftUI

extension MoGL {
    
    /** setup the gl handle with the given context and viewport rectangle with cleared buffer */
    func glutCanvas(_ context: GraphicsContext, _ viewport: CGRect) {
        self.glContext(context)
        self.glViewport(viewport)
        self.glClear()
        self.glFlush()
    }
}
