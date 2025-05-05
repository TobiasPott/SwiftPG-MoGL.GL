//
//  Quaternion.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 23.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//     Adapted to Swift Playground by Tobias Pott (2025)

import SwiftUI

struct GLQuat: Codable {
    var x: CGFloat, y: CGFloat, z: CGFloat = 0, w: CGFloat = 0
    
    init() {
        x = 0; y = 0; z = 0; w = 0
    }
    init(value: CGFloat) {
        x = value; y = value; z = value; w = value
    }
    init(x: CGFloat, y: CGFloat, z: CGFloat, w: CGFloat) {
        self.x = x; self.y = y; self.z = z; self.w = w
    }
    init(other: GLQuat) {
        x = other.x; y = other.y; z = other.z; w = other.w
    }
    init(vector: GLFloat3, w _w: CGFloat) {
        x = vector.x; y = vector.y; z = vector.z
        w = _w
    }
    init(angle: CGFloat, axis: GLFloat3) {
        let q = GLQuat.fromAngleAxis(angle: angle, axis: axis)
        self.init(other: q)
    }
    
    
}

extension GLQuat: CustomStringConvertible {
    var description: String { return "[\(x),\(y),\(z),\(w)]" }
}

extension GLQuat {
    func isFinite() -> Bool {
        return x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }
    
    mutating func set(_ newX: CGFloat, _ newY: CGFloat, _ newZ: CGFloat, _ newW: CGFloat) {
        x = newX
        y = newY
        z = newZ
        w = newW
    }
//      C++ Code  
//    Vector vn = axis.Normalized();
//    
//    angle *=  0.0174532925f; // To radians!
//    angle *= 0.5f;    
//    float sinAngle = sin(angle);
//    
//    return Quaternion(cos(angle), vn.x * sinAngle, vn.y * sinAngle, vn.z * sinAngle);
    
    static func fromAngleAxis(angle: CGFloat, axis: GLFloat3) -> GLQuat {
        var x = axis.x;
        var y = axis.y;
        var z = axis.z;
        
        let length =  1.0 / sqrt( x*x + y*y + z*z )
        
        x = x * length;
        y = y * length;
        z = z * length;
        
        let half = degToRad(angle) * 0.5;
        
        let w = cos(half);
        
        let sin_theta_over_two = sin(half);
        
        x = x * sin_theta_over_two;
        y = y * sin_theta_over_two;
        z = z * sin_theta_over_two;
        
        let result: GLQuat = .init(x: x, y: y, z: z, w: w)
//        print("AngleAxis: \(result)")
        return result
    }
    
    mutating func invert() {
        
        x = -x
        y = -y
        z = -z
    }
    
    mutating func negate() {
        
        x = -x
        y = -y
        z = -z
        w = -w
    }
    
    mutating func zero() {
        
        x = 0
        y = 0
        z = 0
        w = 1
    }
    
    func isIdentityRotation() -> Bool {
        
        return x==0 && y==0 && z==0 && abs(w)==1;
    }
    
    func magnitude() -> CGFloat {
        
        return sqrt( x*x + y*y + z*z + w*w)
    }
    
    func magnitudeSquared() -> CGFloat {
        
        return x*x + y*y + z*z + w*w
    }
    
    func getAngle() -> CGFloat {
        
        return acos(w) * 2.0;
    }
    
    func getAngle(q: GLQuat) -> CGFloat {
        
        return acos( dot(v: q) ) * 2.0;
    }
    
    func dot(v: GLQuat) -> CGFloat {
        return x * v.x + y * v.y + z * v.z  + w * v.w;
    }
    
    mutating func normalize() {
        
        let mag = magnitude();
        
        if mag > 0 {
            
            let length = 1.0 / mag;
            
            x *= length;
            y *= length;
            z *= length;
            w *= length;
        }
    }
    
    mutating func conjugate() {
        
        x = -x;
        y = -y;
        z = -z;
    }
    
    mutating func set(other: GLQuat) {
        
        x = other.x
        y = other.y
        z = other.z
        w = other.w
    }
    
    mutating func slerp(t: CGFloat, left: GLQuat, right: GLQuat) {
        
        let quatEpsilon: CGFloat = 1.0e-8
        
        self.set(other: left)
        
        var cosine: CGFloat =
        x * right.x +
        y * right.y +
        z * right.z +
        w * right.w
        
        var sign: CGFloat = 1.0
        
        if cosine < 0 {
            cosine = -cosine
            sign = -1.0
        }
        
        var sinus: CGFloat = 1.0 - cosine*cosine
        
        if  sinus >= quatEpsilon*quatEpsilon {
            
            sinus = sqrt(sinus)
            
            var angle = atan2(sinus, cosine)
            var i_sin_angle = 1 / sinus
            
            var lower_weight = sin(angle*(1-t)) * i_sin_angle
            var upper_weight = sin(angle * t) * i_sin_angle * sign
            
            w = (w * (lower_weight)) + (right.w * (upper_weight))
            x = (x * (lower_weight)) + (right.x * (upper_weight))
            y = (y * (lower_weight)) + (right.y * (upper_weight))
            z = (z * (lower_weight)) + (right.z * (upper_weight))
        }
        
    }
    
    func rotate(v: inout GLFloat3) {
        
        var myInverse = GLQuat()
        
        myInverse.x = -x
        myInverse.y = -y
        myInverse.z = -z
        myInverse.w =  w
        
        //v = ((*this) * v) ^ myInverse;
        var left = self * v
        
        v.x = left.w * myInverse.x + myInverse.w * left.x + left.y * myInverse.z - myInverse.y*left.z
        v.y = left.w * myInverse.y + myInverse.w * left.y + left.z * myInverse.x - myInverse.z*left.x
        v.z = left.w * myInverse.z + myInverse.w * left.z + left.x * myInverse.y - myInverse.x*left.y
    }
    
    func inverseRotate(v: inout GLFloat3) {
        
        var myInverse = GLQuat()
        
        myInverse.x = -x;
        myInverse.y = -y;
        myInverse.z = -z;
        myInverse.w =  w;
        
        //v = (myInverse * v) ^ (*this);
        
        var left = myInverse * v
        
        v.x = left.w*x + w*left.x + left.y*z - y*left.z
        v.y = left.w*y + w*left.y + left.z*x - z*left.x
        v.z = left.w*z + w*left.z + left.x*y - x*left.y
    }
    
    func rot(v: GLFloat2) -> GLFloat2 {
        return rot(v: GLFloat3(v.x, v.y, 0)).xy
    }
    func rot(v: GLFloat3) -> GLFloat3 {
// https://gamedev.stackexchange.com/questions/28395/rotating-vector3-by-a-quaternion
//        var qv = GLFloat3(x, y, z)
//        var crossDot = (qv.cross(v)) * w + qv * (qv.dot(v))
//        
//        return (v * (w*w - 0.5) + crossDot) * 2.0
        
        var u = GLFloat3(x, y, z)
        var s = w
        
        let a = u * 2.0 * u.dot(v)
        let b = v * (s*s - u.dot(v))
        let c = u.cross(v) * 2.0 * s
        return a + b + c
        /*
        // Extract the vector part of the quaternion
        Vector3 u(q.x, q.y, q.z);
        
        // Extract the scalar part of the quaternion
        float s = q.w;
        
        // Do the math
        vprime = 2.0f * dot(u, v) * u
        + (s*s - dot(u, u)) * v
        + 2.0f * s * cross(u, v);*/
    }
    
    func invRot(v: GLFloat2) -> GLFloat2 {
        return invRot(v: GLFloat3(v.x, v.y, 0)).xy
    }
    func invRot(v: GLFloat3) -> GLFloat3 {
        
        var qv = GLFloat3(x, y, z)
        var crossDot = (qv.cross(v)) * w + qv * (qv.dot(v))
        
        return (v * (w*w - 0.5) - crossDot) * 2.0
    }
    
    func transform(v: GLFloat3, p: GLFloat3) -> GLFloat3 {
        
        return rot(v: v) + p
    }
    
    func invTransform(v: GLFloat3, p: GLFloat3) -> GLFloat3 {
        
        return invRot(v: v - p)
    }
}

func * (left: GLQuat, right : GLQuat) -> GLQuat {
    
    var a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat
    
    a =  -left.x*right.x - left.y*right.y - left.z * right.z
    b =   left.w*right.x + left.y*right.z - right.y * left.z
    c =   left.w*right.y + left.z*right.x - right.z * left.x
    d =   left.w*right.z + left.x*right.y - right.x * left.y
    
    return GLQuat(x: a, y: b, z: c, w: d)
}

func * (left: GLQuat, right : GLFloat3) -> GLQuat {
    var a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat
    
    a = -left.x*right.x - left.y*right.y - left.z * right.z;
    b =  left.w*right.x + left.y*right.z - right.y * left.z;
    c =  left.w*right.y + left.z*right.x - right.z * left.x;
    d =  left.w*right.z + left.x*right.y - right.x * left.y;
    
    return GLQuat(x: a, y: b, z: c, w: d)
}

func * (left: GLQuat, right : CGFloat) -> GLQuat {
    return GLQuat(x: left.x * right, y: left.y * right, z: left.z * right, w: left.w * right);
}

func + (left: GLQuat, right : GLQuat) -> GLQuat {
    return GLQuat(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z, w: left.w + right.w);
}

func - (left: GLQuat, right : GLQuat) -> GLQuat {
    return GLQuat(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z, w: left.w - right.w);
}
