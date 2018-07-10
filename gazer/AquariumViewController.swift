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
        
        let waterTankNode = collada2SCNNode(filepath: "art.scnassets/test.scn")

        let sharkNode = collada2SCNNode(filepath: "art.scnassets/Correctshark002.4.scn")
        
        node.addChildNode(waterTankNode)
        
        node.addChildNode(sharkNode)
        
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
