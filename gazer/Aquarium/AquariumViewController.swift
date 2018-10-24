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
    
    // EAIntroView
    func aquariumIntroView(){
        // １ページ目
        let firstIntro = EAIntroPage()
        firstIntro.title = "ようこそ！"
        firstIntro.desc = """
        画面を注視しながらの歩行は大変危険です。
        画面をタップすると次のページに移ります。
        """
        firstIntro.descPositionY = self.view.bounds.size.height/1.5
        firstIntro.bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // ２ページ目
        let secondIntro = EAIntroPage()
        secondIntro.title = "メニューに戻りたいときは？"
        secondIntro.desc = """
        右にスワイプすると戻れます
        """
        secondIntro.bgImage = UIImage(named:"introSecond")
        
        // 3ページ目
        let thirdIntro = EAIntroPage()
        thirdIntro.title = "水槽をだすには？"
        thirdIntro.desc = """
        壁に向かってタップするとさ水槽が出現します
        """
        thirdIntro.bgImage = UIImage(named: "introThird")
        
        // フォント設定
        firstIntro.titleFont = UIFont(name: "HelveticaNeue-Bold", size: 45)
        firstIntro.descFont = UIFont(name:"HelveticaNeue-Light",size:15)
        secondIntro.descFont = UIFont(name:"HelveticaNeue-Light",size:15)
        secondIntro.titleFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
        thirdIntro.descFont = UIFont(name:"HelveticaNeue-Light",size:15)
        thirdIntro.titleFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [firstIntro,secondIntro,thirdIntro])
        // スキップ
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.delegate = self
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
