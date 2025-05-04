//
//  Math.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 23.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
///     Adapted to Swift Playground by Tobias Pott (2025)

import SwiftUI

func degToRad(a: CGFloat) -> CGFloat { return 0.01745329251994329547 * a; }
func radToDeg(a: CGFloat) -> CGFloat { return 57.29577951308232286465 * a; }

func swapValues<T>(a: inout T, b: inout T) {
    let temp = a
    
    a = b
    b = temp
}

struct Matrix4x4 {
    var m01: CGFloat = 1
    var m02: CGFloat = 0
    var m03: CGFloat = 0
    var m04: CGFloat = 0
    var m05: CGFloat = 0
    var m06: CGFloat = 1
    var m07: CGFloat = 0
    var m08: CGFloat = 0
    var m09: CGFloat = 0
    var m10: CGFloat = 0
    var m11: CGFloat = 1
    var m12: CGFloat = 0
    var m13: CGFloat = 0
    var m14: CGFloat = 0
    var m15: CGFloat = 0
    var m16: CGFloat = 1
}

struct Matrix3x3 {
    
    var m01: CGFloat = 1
    var m02: CGFloat = 0
    var m03: CGFloat = 0
    var m04: CGFloat = 0
    var m05: CGFloat = 1
    var m06: CGFloat = 0
    var m07: CGFloat = 0
    var m08: CGFloat = 0
    var m09: CGFloat = 1
}

extension Matrix3x3: CustomStringConvertible {
    //dispaly in column major (OpenGL like)
    var description: String {
        let row0 = "\(m01),\(m04),\(m07)"
        let row1 = "\(m02),\(m05),\(m08)"
        let row2 = "\(m03),\(m06),\(m09)"
        return "[\(row0),\n\(row1),\n\(row2)]"
    }
}

extension Matrix4x4: CustomStringConvertible {
    //dispaly in column major (OpenGL like)
    var description: String {
        let row0 = "\(m01),\(m05),\(m09),\(m13)"
        let row1 = "\(m02),\(m06),\(m10),\(m14)"
        let row2 = "\(m03),\(m07),\(m11),\(m15)"
        let row3 = "\(m04),\(m08),\(m12),\(m16)"
        return "[\(row0),\n\(row1),\n\(row2),\n\(row3)]"
    }
}


func copyMatrix44(src: [CGFloat], dst: inout Matrix4x4) {
    dst.m01 = src[0]
    dst.m02 = src[1]
    dst.m03 = src[2]
    dst.m04 = src[3]
    dst.m05 = src[4]
    dst.m06 = src[5]
    dst.m07 = src[6]
    dst.m08 = src[7]
    dst.m09 = src[8]
    dst.m10 = src[9]
    dst.m11 = src[10]
    dst.m12 = src[11]
    dst.m13 = src[12]
    dst.m14 = src[13]
    dst.m15 = src[14]
    dst.m16 = src[15]
}

func copyMatrix33(src: [CGFloat], dst: inout Matrix4x4) {
    dst.m01 = src[0]
    dst.m02 = src[1]
    dst.m03 = src[2]
    dst.m04 = src[3]
    dst.m05 = src[4]
    dst.m06 = src[5]
    dst.m07 = src[6]
    dst.m08 = src[7]
    dst.m09 = src[8]
}

func matrix44MakePerspective(fovyRadians: CGFloat, aspect: CGFloat, nearZ: CGFloat, farZ: CGFloat) -> Matrix4x4 {
    let cotan: CGFloat = 1.0 / tan(fovyRadians / 2.0);
    
    let m = [ cotan / aspect, 0.0, 0.0, 0.0,
              0.0, cotan, 0.0, 0.0,
              0.0, 0.0, (farZ + nearZ) / (nearZ - farZ), -1.0,
              0.0, 0.0, (2.0 * farZ * nearZ) / (nearZ - farZ), 0.0]
    
    //TODO: make it direct assing lazy bastard
    var outMat = Matrix4x4()
    copyMatrix44(src: m, dst: &outMat)
    
    return outMat
}

func matrix44MakeFrustum(left: CGFloat, right: CGFloat, bottom: CGFloat, top: CGFloat, nearZ: CGFloat, farZ: CGFloat) -> Matrix4x4 {
    
    let ral = right + left;
    let rsl = right - left;
    let tsb = top - bottom;
    let tab = top + bottom;
    let fan = farZ + nearZ;
    let fsn = farZ - nearZ;
    
    //expression to loooooooooong...
    let a = 2.0 * nearZ / rsl
    let b = 2.0 * nearZ / tsb
    let c = ral / rsl
    let d = tab / tsb
    let e = -fan / fsn
    let f = (-2.0 * farZ * nearZ) / fsn
    
    var m = [ a, 0.0, 0.0, 0.0,
              0.0, b, 0.0, 0.0,
              c,  d,  e, -1.0,
              0.0, 0.0, f, 0.0]
    
    //TODO: make it direct assing lazy bastard
    var outMat = Matrix4x4()
    copyMatrix44(src: m, dst: &outMat)
    
    return outMat
}

func matrix44MakeOrtho(left: CGFloat, right: CGFloat, bottom: CGFloat, top: CGFloat, nearZ: CGFloat, farZ: CGFloat) -> Matrix4x4 {
    
    let ral = right + left;
    let rsl = right - left;
    let tab = top + bottom;
    let tsb = top - bottom;
    let fan = farZ + nearZ;
    let fsn = farZ - nearZ;
    
    var m = [ 2.0 / rsl, 0.0, 0.0, 0.0,
              0.0, 2.0 / tsb, 0.0, 0.0,
              0.0, 0.0, -2.0 / fsn, 0.0,
              -ral / rsl, -tab / tsb, -fan / fsn, 1.0]
    
    //TODO: make it direct assing lazy bastard
    var outMat = Matrix4x4()
    copyMatrix44(src: m, dst: &outMat)
    
    return outMat
}

func matrix44MakeLookAt(eye: GLFloat3, center: GLFloat3, up: GLFloat3) -> Matrix4x4{
    var ev = eye
    var cv = center
    var uv = up
    
    cv.negate()
    
    var n: GLFloat3 = ev + cv
    n.normalize()
    
    var u: GLFloat3 = uv.cross(n)
    u.normalize()
    
    let v: GLFloat3 = n.cross(u)
    var un = GLFloat3(u)
    var vn = GLFloat3(v)
    var nn = GLFloat3(n)
    
    un.negate()
    vn.negate()
    nn.negate()
    
    var m = [u.x, v.x, n.x, 0.0,
             u.y, v.y, n.y, 0.0,
             u.z, v.z, n.z, 0.0,
             un.dot(ev), vn.dot(ev), nn.dot(ev), 1.0]
    
    //TODO: make it direct assing lazy bastard
    var outMat = Matrix4x4()
    copyMatrix44(src: m, dst: &outMat)
    
    return outMat
}
