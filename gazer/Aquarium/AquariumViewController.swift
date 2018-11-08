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
import SCLAlertView
import EAIntroView

class AquariumViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate, EAIntroDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
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
        audioPlayer.stop()
    }
    
    //音楽インスタンス
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aquariumIntroView()
        
        sceneView.delegate = self
        
        //BGM再生a
        playSound(name: "aqua_bgm")
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
        var waterTankNode = collada2SCNNode(filepath: "AquariumModel/case.scn")
        
        if randomNum == 0 {
            waterTankNode = collada2SCNNode(filepath: "AquariumModel/set1.scn")
        } else {
            waterTankNode = collada2SCNNode(filepath: "AquariumModel/case.scn")
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
    
    
    // EAIntroView
    func aquariumIntroView(){
        // １ページ目
        let firstIntro = EAIntroPage()
        firstIntro.alpha = 0.9
        switch (UIScreen.main.nativeBounds.height) {
        case 2436:
            firstIntro.bgImage = UIImage(named:"wtAqua10")
            break
        default:
            firstIntro.bgImage = UIImage(named:"wtAqua")
            break
        }
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [firstIntro])
        
        // スキップボタン、ページコントロールを不可視化
        introView?.skipButton.setTitle("", for: UIControl.State.normal)
        introView?.delegate = self
        introView?.pageControlY = -300
        
        // タップで次へ進む
        introView?.tapToNext = true
        // 画面立ち上げ
        introView?.show(in: self.view, animateDuration: 1.0)
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
