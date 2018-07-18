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

class MappingViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true
    
    // Create a new scene
    let scene = SCNScene()
    //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    
    // Set the scene to the view
    sceneView.scene = scene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.vertical, .horizontal]
    //画像認識を可能に設定
    configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    guard let cuptureImage = sceneView.session.currentFrame?.capturedImage else {
      return
    }
    
    // PixelBuffer を CIImage に変換しフィルターをかける
    let ciImage = CIImage.init(cvPixelBuffer: cuptureImage)
    let filter:CIFilter = CIFilter(name: "CIColorMonochrome")!
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(CIColor(red: 0.3, green: 0.3, blue: 0.3), forKey: "inputColor")
    filter.setValue(1.0, forKey: "inputIntensity")
    
    //　CIImage を CGImage に変換して背景に適応
    //　カメラ画像はホーム右のランドスケープの状態で画像が渡されるため、CGImagePropertyOrientation(rawValue: 6) でポートレートで正しい向きに表示されるよう変換
    let context = CIContext()
    let result = filter.outputImage!.oriented(CGImagePropertyOrientation(rawValue: 6)!)
    if let cgImage = context.createCGImage(result, from: result.extent) {
      sceneView.scene.background.contents = cgImage
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let imageAnchor = anchor as? ARImageAnchor{
        if(node.geometry == nil){
          let plane = SCNPlane()
          plane.width = imageAnchor.referenceImage.physicalSize.width
          plane.height = (imageAnchor.referenceImage.physicalSize.height) * 1.8
          node.geometry = plane
        }
        
        node.simdTransform = imageAnchor.transform
        node.geometry?.firstMaterial = self.createMaterial()
        node.eulerAngles.x = 0
        //原点の移動
        node.pivot = SCNMatrix4MakeTranslation(0.0, -0.5, 0.0)
      }
    }
  }
  
  func createMaterial() -> SCNMaterial {
    // ビデオのURL
    let videoUrl = Bundle.main.url(forResource: "default", withExtension: "mp4")!
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
    skNode.play() // 再生開始
    // SKSceneに、SKVideoNodeを追加する
    skScene.addChild(skNode)
    
    let material = SCNMaterial()
    material.diffuse.contents = skScene
    material.transparency = 0.5
    return material
  }
  
  
  
  func session(_ session: ARSession, didFailWithError error: Error) {
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
  }
}
