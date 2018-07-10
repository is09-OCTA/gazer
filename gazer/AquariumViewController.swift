//
//  AquariumViewController.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/06/18.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class AquariumViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
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
    
    // 平面検知時に呼び出される
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("垂直検知")
        
      //  let waterTankNode = collada2SCNNode(filepath: "art.scnassets/test.scn")
        
      //  node.addChildNode(waterTankNode)
        
        // .daeファイルの読み込み
        let maruScene = SCNScene(named: "art.scnassets/test.dae")!
        // 読み込んだ.daeファイルのマテリアルを指定して、ノードを作成
        let maruNode = maruScene.rootNode.childNode(withName: "tankuMaru", recursively: true)
        // SCNodeのscaleとpositionの編集
        // カメラの中心位置から左に1m、下に2m、奥行きを2mずらして表示
        maruNode?.position = SCNVector3 (-1,-2,-2)
        
        // ピッチを10度、ヨーを-5度、ロールを0度回転。
        // maruNode?.eulerAngles = SCNVector3(10 * (Float.pi / 180), -5 * (Float.pi / 180), 0)
        
        //3Dモデルの実サイズに対して1/3倍のスケールで表示。
        maruNode?.scale = SCNVector3(0.3,0.3,0.3)
        
        // 取得したノードをシーンに追加
        self.sceneView.scene.rootNode.addChildNode(maruNode!)
        
        // オムニライト
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        
        // アンビエントライト
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.sceneView.scene.rootNode.addChildNode(lightNode)
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        self.sceneView.scene.rootNode.addChildNode(lightNode)
        
        
    }
    
    // collada2SCNNode
    func collada2SCNNode(filepath: String) -> SCNNode {
        let node = SCNNode()
        let scene = SCNScene(named: filepath)
        let nodeArray = scene!.rootNode.childNodes
        
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
        }
        return node
    }
}
