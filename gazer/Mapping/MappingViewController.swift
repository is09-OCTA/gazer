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
    
    // Set the view's delegate
    sceneView.delegate = self as ARSCNViewDelegate
    
    // Create a new scene
    let scene = SCNScene()
    
    // Set the scene to the view
    sceneView.scene = scene
    buttonConf = ButtonConf()
    self.view.addSubview((buttonConf?.NodeSelectionButton(mappingViewController: self))!)
    self.registerGestureRecognizer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    
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
    // シーン未選択、前回のシーンと一致であれば無視
    if (beforeSceneType == sceneType) || (self.sceneType == nil) {
      return
    }
    self.addItem()
  }
  
  private func addItem() {
    sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
      node.removeFromParentNode()
    }
    sceneView.scene.rootNode.removeFromParentNode()
    switch sceneType {
    case "DisneyCastleNode":
      objectNode = DisneyCastleNode()
      sceneView.scene.rootNode.addChildNode(objectNode! as! DisneyCastleNode)
    case "PictureNode":
      objectNode = PictureNode()
      sceneView.scene.rootNode.addChildNode(objectNode! as! PictureNode)
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
