//
//  ButtonConf.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/11/15.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import UIKit
import Floaty

final class ButtonConf: FloatyDelegate {
  var floaty: Floaty
  
  init() {
    floaty = Floaty()
    Floaty.global.rtlMode = true
  }
  
  func NodeSelectionButton(mappingViewController: MappingViewController) -> Floaty{
    self.floaty.buttonImage = UIImage(named: "MappingMenu2")
    self.floaty.paddingX = 16
    if #available(iOS 11.0, *) {
      self.floaty.paddingY = 30 + (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom)!
    } else {
      self.floaty.paddingY = 30
    }
    self.floaty.buttonColor = UIColor.init(white: 1, alpha: 0)
    self.floaty.size = 50
    
    let item = FloatyItem()
    item.buttonColor = UIColor.init(red: 1, green: 1, blue: 0.6, alpha: 1)
    //item.icon = UIImage(named: "castle")
    item.title = "Scene1"
    item.handler = {item in
      mappingViewController.sceneType = "DisneyCastleNode"
    }
    self.floaty.addItem(item: item)
    
    let item2 = FloatyItem()
    item2.buttonColor = UIColor.init(red: 0.6, green: 0.8, blue: 1, alpha: 1)
    //item2.icon = UIImage(named: "siro")
    item2.title = "Scene2"
    item2.handler = {item in
      mappingViewController.sceneType = "PictureNode"
    }
    self.floaty.addItem(item: item2)
    
    
    let item5 = FloatyItem()
    item5.buttonColor = UIColor.init(red: 1, green: 0.6, blue: 0.6, alpha: 1)
    //item5.icon = UIImage(named: "test")
    item5.title = "Scene3"
    item5.handler = {item in
      mappingViewController.sceneType = "BoxNode"
    }
    self.floaty.addItem(item: item5)
    
    return self.floaty
  }
}
