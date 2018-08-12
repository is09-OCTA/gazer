//
//  MappingViewController.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/07/17.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import AVFoundation

class MappingViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  var audioPlayer: AVAudioPlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true
    
    // Create a new scene
    let scene = SCNScene()
    
    // Set the scene to the view
    sceneView.scene = scene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.vertical, .horizontal]
    //画像認識を可能に設定
    guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
      fatalError("Missing expected asset catalog resources.")
    }
    configuration.detectionImages = referenceImages
    
    
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // 背景を暗くする
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    guard let cuptureImage = sceneView.session.currentFrame?.capturedImage else {
      return
    }
    
    // PixelBuffer を CIImage に変換しフィルターをかける
    let ciImage = CIImage.init(cvPixelBuffer: cuptureImage)
    let filter:CIFilter = CIFilter(name: "CIColorMonochrome")!
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(CIColor(red: 0.2, green: 0.2, blue: 0.2), forKey: "inputColor")
    filter.setValue(1.0, forKey: "inputIntensity")
    
    // CIImage を CGImage に変換して背景に適応
    // カメラ画像はホーム右のランドスケープの状態で画像が渡されるため、CGImagePropertyOrientation(rawValue: 6) でポートレートで正しい向きに表示されるよう変換
    let context = CIContext()
    let result = filter.outputImage!.oriented(CGImagePropertyOrientation(rawValue: 6)!)
    if let cgImage = context.createCGImage(result, from: result.extent) {
      sceneView.scene.background.contents = cgImage
    }
  }
  
  
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      guard let imageAnchor = anchor as? ARImageAnchor else {
        print("Error: This anchor is not ARPlaneAnchor. [\(#function)]")
        return
      }
      
      guard let geometryPlaneNode = node.childNodes.first,
        let plane = geometryPlaneNode.geometry as? SCNPlane else {
          print("Error: SCNPlane node is not found. [\(#function)]")
          return
      }
      plane.width = imageAnchor.referenceImage.physicalSize.width
      plane.height = (imageAnchor.referenceImage.physicalSize.height) * 2.1
      node.simdTransform = imageAnchor.transform
      node.eulerAngles.x = 0
      // 原点の移動
      node.pivot = SCNMatrix4MakeTranslation(0.0, 0.7, 0.0)
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let imageAnchor = anchor as? ARImageAnchor{
        if(node.geometry == nil){
          let plane = SCNPlane()
          // ビデオのURL
          let videoVideoUrl = Bundle.main.url(forResource: "main", withExtension: "mp4")!
          let rockVideoUrl = Bundle.main.url(forResource: "RockMaterial2", withExtension: "mp4")!
          plane.width = imageAnchor.referenceImage.physicalSize.width
          plane.height = (imageAnchor.referenceImage.physicalSize.height) * 2.1
          let videoNode = SCNNode()
          videoNode.geometry = plane
          let videoMaterial = self.createMaterial(videoUrl: videoVideoUrl, alpha: 0.7,angle: 0.0)
          videoNode.geometry?.firstMaterial = videoMaterial
          node.addChildNode(videoNode as SCNNode)
          
          let rockNode = MappingViewController.collada2SCNNode(filepath: "art.scnassets/Mossy Rock - stump.scn")
          let rockMaterial = self.createMaterial(videoUrl: rockVideoUrl, alpha: 1.0,angle: 90.0)
          rockNode.childNodes[0].geometry?.firstMaterial = rockMaterial
          node.addChildNode(rockNode as SCNNode)
          
        }
        //ライト
        let lightNode = SCNNode()
         lightNode.light = SCNLight()
         lightNode.light?.type = .ambient
         lightNode.position = SCNVector3(x:0, y:10, z:1)
         node.addChildNode(lightNode as SCNNode)
        
        
        node.simdTransform = imageAnchor.transform
        node.eulerAngles.x = 0
        self.playSound(name: "sound")
      }
    }
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
    skNode.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
    skNode.size = skScene.size
    skNode.yScale = -1.0 // 座標系を上下逆にする
    skNode.zRotation = CGFloat(angle)
    skNode.play() // 再生開始
    // SKSceneに、SKVideoNodeを追加する
    skScene.addChild(skNode)
    
    let material = SCNMaterial()
    material.diffuse.contents = skScene
    material.transparency = CGFloat(alpha)
    return material
  }
  
  // collada2SCNNode
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
      audioPlayer.delegate = self
      
      // 音声の再生
      audioPlayer.play()
    } catch {
    }
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
  }
}
