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
import AVFoundation

class AquariumViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    //音楽インスタンス
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        //BGM再生
        playSound(name: "art.scnassets/AQUA_BGM")
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
        
        let randomNum = arc4random_uniform(2)
        var waterTankNode = collada2SCNNode(filepath: "art.scnassets/test.scn")
        
        if randomNum == 0 {
            waterTankNode = collada2SCNNode(filepath: "art.scnassets/test.scn")
        } else {
            waterTankNode = collada2SCNNode(filepath: "art.scnassets/test2.scn")
        }
        
        node.addChildNode(waterTankNode)
        
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
    
    //BGM
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
            
            //ループ再生
            audioPlayer.numberOfLoops = -1
            
            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}
