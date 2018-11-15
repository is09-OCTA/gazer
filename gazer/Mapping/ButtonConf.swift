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
    self.floaty.paddingY = 30
    self.floaty.buttonColor = UIColor.init(white: 1, alpha: 0)
    self.floaty.size = 50
    
    let item = FloatyItem()
    item.buttonColor = UIColor.init(red: 1, green: 1, blue: 0.6, alpha: 1)
    //item.icon = UIImage(named: "castle")
    item.title = "Scene1-1"
    item.handler = {item in
      mappingViewController.sceneType = "DisneyCastleNode"
    }
    
    self.floaty.addItem(item: item)
    let item4 = FloatyItem()
    item4.buttonColor = UIColor.init(red: 1, green: 1, blue: 0.6, alpha: 1)
    //item4.icon = UIImage(named: "castle")
    item4.title = "Scene1-2"
    item4.handler = {item in
      
    }
    
    self.floaty.addItem(item: item4)
    
    let item2 = FloatyItem()
    item2.buttonColor = UIColor.init(red: 0.6, green: 0.8, blue: 1, alpha: 1)
    //item2.icon = UIImage(named: "siro")
    item2.title = "Scene2-1"
    self.floaty.addItem(item: item2)
    
    let item3 = FloatyItem()
    item3.buttonColor = UIColor.init(red: 0.6, green: 0.8, blue: 1, alpha: 1)
    //item3.icon = UIImage(named: "siro")
    item3.title = "Scene2-2"
    self.floaty.addItem(item: item3)
    
    let item5 = FloatyItem()
    item5.buttonColor = UIColor.init(red: 1, green: 0.6, blue: 0.6, alpha: 1)
    //item5.icon = UIImage(named: "test")
    item5.title = "Scene3-1"
    self.floaty.addItem(item: item5)
    
    let item6 = FloatyItem()
    item6.buttonColor = UIColor.init(red: 1, green: 0.6, blue: 0.6, alpha: 1)
    //item6.icon = UIImage(named: "test")
    item6.title = "Scene3-2"
    self.floaty.addItem(item: item6)
    
    return self.floaty
  }
}
