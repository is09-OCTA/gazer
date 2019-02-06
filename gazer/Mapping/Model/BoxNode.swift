//
//  BoxNode.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/12/14.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import AVFoundation

class BoxNode: SCNNode {
  public var audioPlayer: AVAudioPlayer!
  public var skNode: SKVideoNode!
  
  init(position: SCNVector3,nodeEulerAnglesY: Float) {
    super.init()
    let node = BoxNode.collada2SCNNode(filepath: "MappingModel.scnassets/Box.scn")
    let boxVideoUrl = Bundle.main.url(forResource: "Box", withExtension: "mp4")!
    let boxMaterial = self.createMaterial(videoUrl: boxVideoUrl, alpha: 1.0,angle: 0.0)
    node.childNodes[0].geometry?.firstMaterial = boxMaterial
    node.position = position
    node.eulerAngles.y = nodeEulerAnglesY
    
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
    skNode = SKVideoNode(avPlayer: avPlayer)
    // シーンと同じサイズとし、中央に配置する
    skNode.position = CGPoint(x: (skScene.size.width / 2.0), y: (skScene.size.height / 2.0))
    skNode.size.height = skScene.size.height
    skNode.size.width = skScene.size.width
    skNode.yScale = -1
    skNode.xScale = 1
    skNode.zRotation = CGFloat(angle)
    //skNode.play() // 再生開始
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.playSound(name: "Scene3")
    }
    // SKSceneに、SKVideoNodeを追加する
    skScene.addChild(skNode)
    
    let material = SCNMaterial()
    material.diffuse.contents = skScene
    material.transparency = CGFloat(alpha)
    return material
  }
  
  func playVideo() {
    skNode.play()
  }
  
  // サウンド再生メソッド
  func playSound(name: String) {
    guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
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
