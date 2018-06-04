//
//  ButtonCustom.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/06/04.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import UIKit

//classをこれにするとMain.storyboard上でボタンの設定ができます。
@IBDesignable
class ButtonCustom: UIButton {
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
