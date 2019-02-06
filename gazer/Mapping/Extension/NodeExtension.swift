//
//  NodeExtension.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/12/16.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import SceneKit
import AVFoundation

extension SCNNode {
  // scnファイルをnode化
  public class func collada2SCNNode(filepath:String) -> SCNNode {
    let node = SCNNode()
    let scene = SCNScene(named: filepath)
    let nodeArray = scene!.rootNode.childNodes
    
    for childNode in nodeArray {
      node.addChildNode(childNode as SCNNode)
    }
    return node
  }
  
}
