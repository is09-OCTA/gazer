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

class MappingViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  var disneyCastleNode: DisneyCastleNode?
    
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
        if disneyCastleNode?.audioPlayer.isPlaying == true { disneyCastleNode?.audioPlayer.stop() }
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self as ARSCNViewDelegate
    
    // Create a new scene
    let scene = SCNScene()
    
    // Set the scene to the view
    sceneView.scene = scene
    self.registerGestureRecognizer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  //tap設定
  private func registerGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MappingViewController.tapped))
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func tapped(sender: UITapGestureRecognizer) {
    // すでに追加済みであれば無視
    if self.disneyCastleNode != nil {
      return
    }
    self.addItem()
  }
  
  private func addItem() {
    disneyCastleNode = DisneyCastleNode()
    sceneView.scene.rootNode.addChildNode(disneyCastleNode!)
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
