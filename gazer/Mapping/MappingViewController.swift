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
import SCLAlertView
import Floaty

class MappingViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  var objectNode: Any?
  var buttonConf: ButtonConf?
  var sceneType: String?
  var beforeSceneType: String?
  
  @IBOutlet weak var button: UIButton!
  
  @IBAction func pushCamera(_ sender: Any) {
    button.isHidden = true //ボタン非表示
    let image = getScreenShot()
    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    
    SCLAlertView().showSuccess("お知らせ", subTitle: "写真を保存しました！", closeButtonTitle: "OK")
    button.isHidden = false //ボタン表示
  }
  
  // スワイプしたらメニュー画面戻る
  @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
    beforeMenu.modalTransitionStyle = .crossDissolve
    present(beforeMenu, animated: true, completion: nil)
    if objectNode != nil {
      if (objectNode as! DisneyCastleNode).audioPlayer.isPlaying == true { (objectNode as! DisneyCastleNode).audioPlayer.stop() }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self as ARSCNViewDelegate
    
    let scene = SCNScene()
    
    sceneView.scene = scene
    buttonConf = ButtonConf()
    self.view.addSubview((buttonConf?.NodeSelectionButton(mappingViewController: self))!)
    self.registerGestureRecognizer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal,.vertical]
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  //tap設定
  private func registerGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MappingViewController.tapped))
    tapGestureRecognizer.cancelsTouchesInView = false
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func tapped(sender: UITapGestureRecognizer) {
    var nodePosition: SCNVector3?
    var nodeEulerAnglesY: Float?
    
    
    // シーン未選択、前回のシーンと一致であれば無視
    if sceneType == "PictureNode" {
      
    } else if (beforeSceneType == sceneType) || (self.sceneType == nil) {
      return
    }
    
    // sceneView上でタップした座標を検出
    let location = sender.location(in: sceneView)
    //現実座標取得
    let hitTestResult = sceneView.hitTest(location, types: .existingPlane)
    //アンラップ
    if let result = hitTestResult.first {
      nodePosition = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
      if let camera = sceneView.pointOfView {
        nodeEulerAnglesY = camera.eulerAngles.y  // カメラのオイラー角と同じにする
      }
      self.addItem(position: nodePosition!, nodeEulerAnglesY: nodeEulerAnglesY!)
    }
    
  }
  
  private func addItem(position: SCNVector3,nodeEulerAnglesY: Float) {
    if (sceneType != "PictureNode") || (sceneView.scene.rootNode.childNodes.filter({ $0.name == "pictureNode" }).count == 0){
      sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode()
      }
    }
    switch sceneType {
    case "DisneyCastleNode":
      objectNode = DisneyCastleNode(position: position, nodeEulerAnglesY: nodeEulerAnglesY)
      sceneView.scene.rootNode.addChildNode(objectNode! as! DisneyCastleNode)
    case "PictureNode":
      let pictureNode = PictureNode(position: position, nodeEulerAnglesY: nodeEulerAnglesY)
      pictureNode.name = "pictureNode"
      sceneView.scene.rootNode.addChildNode(pictureNode)
    default:
      break
    }
    beforeSceneType = sceneType
  }
  
  
  // Camera
  private func getScreenShot() -> UIImage? {
    guard let view = self.view else {
      return nil
    }
    
    UIGraphicsBeginImageContext(view.frame.size)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
}
