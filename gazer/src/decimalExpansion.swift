//
//  decimalExpansion.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/05/16.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation

extension Decimal {
    
    var abs: Decimal {
        return self < 0 ? -self : self
    }
    
    static let two_pi = Decimal.pi * 2
    static let pi_two = Decimal.pi / 2
    
    var floor: Decimal {
        let behavior = NSDecimalNumberHandler(roundingMode: .down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return (self as NSDecimalNumber).rounding(accordingToBehavior: behavior) as Decimal
    }
    
    func mul(_ y: Decimal) -> Decimal {
        let r = self * y
        if self.abs < 1 && y.abs < 1 && r.abs >= 1 {
            return .nan
        }
        return r
    }
    
    func nomalizeRadian() -> Decimal {
        let t = (self / (.pi * 2)).floor
        return self - (t * (.pi * 2))
    }
    
    func sin() -> Decimal {
        if isNaN { return .nan }
        var angle = nomalizeRadian()
        var sign: Decimal = 1
        if .pi_two < angle && angle <= .pi { angle = .pi - angle }
        else if .pi < angle && angle <= .pi_two * 3 { angle -= .pi; sign = -1 }
        else if .pi_two * 3 < angle { angle = .two_pi - angle; sign = -1 }
        
        let square = angle.mul(angle)
        var coef = angle
        var coefs = [coef]
        for i in 1...19 {
            coef = coef.mul(-square / Decimal(2 * i * (2 * i + 1)))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res = coefs.reversed().reduce(0, { $0 + $1 })
        return res * sign
    }
    
    func cos() -> Decimal {
        if isNaN { return .nan }
        var angle = nomalizeRadian()
        var sign: Decimal = 1
        if .pi_two < angle && angle <= .pi { angle = .pi - angle; sign = -1 }
        else if .pi < angle && angle <= .pi_two * 3 { angle -= .pi; sign = -1 }
        else if .pi_two * 3 < angle { angle = .two_pi - angle }
        
        let square = angle.mul(angle)
        var coef: Decimal = 1
        var coefs = [coef]
        for i in 1...19 {
            coef = coef.mul(-square / Decimal((2 * i - 1) * 2 * i))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res = coefs.reversed().reduce(0, { $0 + $1 })
        return res * sign
    }
}
