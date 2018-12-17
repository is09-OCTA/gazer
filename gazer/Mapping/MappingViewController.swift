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
import Floaty

class MappingViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  //var objectNode: SCNNode?
  var buttonConf: ButtonConf?
  var sceneType: String?
  var beforeSceneType: String?
  var disneyCastleNode: DisneyCastleNode?
  var boxNode: BoxNode?
  
  @IBOutlet weak var button: UIButton!
  
  var mappingSaveImage:UIImage! = nil
  
  @IBAction func pushCamera(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(
      UIImagePickerController.SourceType.camera){
      
      button.isHidden = true //ボタン非表示
      buttonConf!.floaty.isHidden = true
      
      mappingSaveImage = getScreenShot()
      performSegue(withIdentifier: "prevPhoto", sender: nil)
      
      button.isHidden = false //ボタン表示
      buttonConf!.floaty.isHidden = false
      
    }
    else{
      
      let alert = UIAlertController(title: "カメラへのアクセスが拒否されています。", message: "設定画面よりアクセスを許可してください。", preferredStyle:.alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
    }
  }
  
  // スワイプしたらメニュー画面戻る
  @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
    beforeMenu.modalTransitionStyle = .crossDissolve
    present(beforeMenu, animated: true, completion: nil)
    musicStop()
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
      musicStop()
      sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode()
      }
    }
    switch sceneType {
    case "DisneyCastleNode":
      disneyCastleNode = DisneyCastleNode(position: position, nodeEulerAnglesY: nodeEulerAnglesY)
      disneyCastleNode?.name = "disneyCastleNode"
      sceneView.scene.rootNode.addChildNode(disneyCastleNode!)
    case "PictureNode":
      let pictureNode = PictureNode(position: position, nodeEulerAnglesY: nodeEulerAnglesY)
      pictureNode.name = "pictureNode"
      sceneView.scene.rootNode.addChildNode(pictureNode)
    case "BoxNode":
      boxNode = BoxNode(position: position, nodeEulerAnglesY: nodeEulerAnglesY)
      boxNode?.name = "boxNode"
      boxNode?.playVideo()
      sceneView.scene.rootNode.addChildNode(boxNode!)
    default:
      break
    }
    beforeSceneType = sceneType
  }
  
  func musicStop() {
    if sceneView.scene.rootNode.childNodes.filter({ $0.name == "disneyCastleNode" }).count > 0 {
      disneyCastleNode?.audioPlayer.stop()
    } else if sceneView.scene.rootNode.childNodes.filter({ $0.name == "boxNode" }).count > 0 {
      boxNode?.audioPlayer.stop()
    }
  }
  
  // Camera
  private func getScreenShot() -> UIImage? {
    guard let view = self.view else {
      return nil
    }
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
  // PhotoPreViewControllerに受け渡し
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let photo = segue.destination as! PhotoPreViewController
    photo.screenImage = mappingSaveImage
    photo.addImage = 4
  }
  
}
