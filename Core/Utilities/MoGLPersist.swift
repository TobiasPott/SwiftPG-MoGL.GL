import SwiftUI

struct MoGLPersist {
//    
//    // ToDo: implement saveCamera and loadCamera which both expect a camera object and either load from user defaults or store the given parameters to the user defaults
//    // ToDo: need a function to clear all stored user defaults (just to cleanup)
//    static func load(_ tfs: Transform, _ prefix: String = "transform") {
//        let ud = UserDefaults.standard
//        tfs.x = CGFloat(ud.float(forKey: prefix + ".location.x"))
//        tfs.y = CGFloat(ud.float(forKey: prefix + ".location.y"))
//        tfs.z = CGFloat(ud.float(forKey: prefix + ".location.z"))
//        tfs.a = CGFloat(ud.float(forKey: prefix + ".a"))
//        tfs.t = CGFloat(ud.float(forKey: prefix + ".t"))
////        tfs.scale = Vector3(ud.object(forKey: prefix + ".scale"))
//        // try get pivot data if not existent set to nil
//        if let data: Data = ud.object(forKey: prefix + ".pivot") as? Data {
////            tfs.setPivot(newValue: GLFloat3.decodeFromJson(data))  
//        } else { tfs.setPivot(newValue: nil) }
//    }
//    static func save(_ tfs: Transform, _ prefix: String = "transform") {
//        let ud = UserDefaults.standard
//        ud.setValue(tfs.location, forKey: prefix + ".location")
//        ud.setValue(tfs.a, forKey: prefix + ".a")
//        ud.setValue(tfs.t, forKey: prefix + ".t")
////        ud.setValue(GLFloat3.encodeToJson(tfs.scale), forKey: prefix + ".scale")
//        if tfs.useCustomPivot {
////            ud.setValue(GLFloat3.encodeToJson(tfs.pivot), forKey: prefix + ".pivot")
//        } else { ud.removeObject(forKey: prefix + ".pivot") }
//    }
//    static func delete(_ tfs: Transform, _ prefix: String = "transform") {
//        let ud = UserDefaults.standard
//        ud.removeObject(forKey: prefix + ".location")
//        ud.removeObject(forKey: prefix + ".a")
//        ud.removeObject(forKey: prefix + ".t")
//        ud.removeObject(forKey: prefix + ".scale")
//        ud.removeObject(forKey: prefix + ".pivot")
//    }
//    
}


