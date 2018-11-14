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

class MappingViewController: UIViewController, ARSCNViewDelegate, FloatyDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  var disneyCastleNode: DisneyCastleNode?
  var floaty = Floaty()
    
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
    Floaty.global.rtlMode = true
    NodeSelectionButton()
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
    tapGestureRecognizer.cancelsTouchesInView = false
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func tapped(sender: UITapGestureRecognizer) {
    // すでに追加済みであれば無視
    if self.disneyCastleNode != nil {
      return
    }
    //self.addItem()
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
  
  func NodeSelectionButton(){
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
    
    self.view.addSubview(floaty)
  }
}
