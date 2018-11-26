//
//  PictureNode.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/11/19.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import AVFoundation

class PictureNode: SCNNode {
  public var audioPlayer: AVAudioPlayer!
  
  
  init(position: SCNVector3,nodeEulerAnglesY: Float) {
    super.init()
    let node = DisneyCastleNode.collada2SCNNode(filepath: "MappingModel.scnassets/Monitor.scn")
    
    var videoName: String?
    var videoRotation: Float?
    var videoEulerAngles: Float?
    let randomNum = arc4random_uniform(3)
    switch randomNum {
    case 0:
      videoName = "blackwaves"
      videoRotation = 0.0
      videoEulerAngles = 0.0
    case 1:
      videoName = "lifesurvives"
      videoRotation = 90.0
      videoEulerAngles = 90.0
    case 2:
      videoName = "flower"
      videoRotation = 90.0
      videoEulerAngles = 90.0
    default:
      break
    }
    
    
    let cinderellaCastleVideoUrl = Bundle.main.url(forResource: videoName!, withExtension: "mp4")!
    let cinderellaCastleMaterial = self.createMaterial(videoUrl: cinderellaCastleVideoUrl, alpha: 1.0,angle: videoRotation!)
    node.childNodes[0].geometry?.firstMaterial = cinderellaCastleMaterial
    node.position = position
    node.eulerAngles.y = nodeEulerAnglesY
    node.eulerAngles.z = videoEulerAngles!
    self.addChildNode(node)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // オブジェクト用の動画 materialを生成
  func createMaterial(videoUrl: URL,alpha: Float,angle: Float) -> SCNMaterial {
    // AVPlayerを生成する
    let avPlayer = AVPlayer(url: videoUrl)
    // SKSceneを生成する
    let skScene = SKScene(size: CGSize(width: 1000, height: 1000))
    // AVPlayerからSKVideoNodeの生成する
    let skNode = SKVideoNode(avPlayer: avPlayer)
    // シーンと同じサイズとし、中央に配置する
    //skNode.position = CGPoint(x: (skScene.size.width / 2.0) + 22, y: (skScene.size.height / 2.0) - 40)  //フルバージョン
    skNode.position = CGPoint(x: (skScene.size.width / 2.0) + 45, y: (skScene.size.height / 2.0) - 20)
    skNode.size.height = skScene.size.height
    skNode.size.width = skScene.size.width + 300
    //skNode.yScale = -1.07 //フルバージョン
    //skNode.xScale = 0.8 //フルバージョン
    skNode.yScale = -0.95
    skNode.xScale = 0.9
    skNode.zRotation = CGFloat(angle)
    skNode.play() // 再生開始
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.playSound(name: "Disney")
    }
    // SKSceneに、SKVideoNodeを追加する
    skScene.addChild(skNode)
    
    let material = SCNMaterial()
    material.diffuse.contents = skScene
    material.transparency = CGFloat(alpha)
    return material
  }
  
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
  // サウンド再生メソッド
  func playSound(name: String) {
    guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
      print("音源ファイルが見つかりません")
      return
    }
    
    do {
      // AVAudioPlayerのインスタンス化
      audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
      
      // AVAudioPlayerのデリゲートをセット
      audioPlayer.delegate = self as? AVAudioPlayerDelegate
      
      // 音声の再生
      audioPlayer.play()
    } catch {
    }
  }
}
