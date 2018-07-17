//
//  ZooViewController.swift
//  gazer
//
//  Created by 杉岡 成哉 on 2018/07/17.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ZooViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self
    // 特徴点表示
    sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    let scene = SCNScene()
    sceneView.scene = scene
    // tapアクション追加
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
    sceneView.addGestureRecognizer(gesture)
  }
  
  @objc func tapView(sender: UITapGestureRecognizer) {
    // sceneView上でタップした座標を検出
    let location = sender.location(in: sceneView)
    //現実座標取得
    let hitTestResult = sceneView.hitTest(location, types: .existingPlane)
    //アンラップ
    if let result = hitTestResult.first {
      let node = ZooViewController.collada2SCNNode(filepath: "art.scnassets/Lion.scn")
      node.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
      sceneView.scene.rootNode.addChildNode(node)
    }
  }
  //collada2SCNNode
  class func collada2SCNNode(filepath:String) -> SCNNode {
    let node = SCNNode()
    let scene = SCNScene(named: filepath)
    let nodeArray = scene!.rootNode.childNodes
    
    for childNode in nodeArray {
      node.addChildNode(childNode as SCNNode)
    }
    return node
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    //平面検出
    configuration.planeDetection = .horizontal
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
  }
}
