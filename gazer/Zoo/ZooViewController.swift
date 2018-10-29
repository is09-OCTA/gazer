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
import SCLAlertView
import EAIntroView

class ZooViewController: UIViewController, ARSCNViewDelegate ,EAIntroDelegate{
  
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var animalButton: UIButton!
    
    @IBAction func pushCamera(_ sender: Any) {
        cameraButton.isHidden = true //ボタン非表示
        animalButton.isHidden = true
        
        let image = getScreenShot()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        SCLAlertView().showSuccess("お知らせ", subTitle: "写真を保存しました！", closeButtonTitle: "OK")
        cameraButton.isHidden = false //ボタン表示
        animalButton.isHidden = false
    }
    
    // スワイプしたらメニュー画面戻る
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
        beforeMenu.modalTransitionStyle = .crossDissolve
        present(beforeMenu, animated: true, completion: nil)
    }
    
    @IBAction func openButton(_ sender: UIButton) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "ModalViewController")
        modalViewController?.modalPresentationStyle = .custom
        modalViewController?.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        present(modalViewController!, animated: true, completion: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zooIntroView()
    
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
        
        // AppDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let filepath = appDelegate.path
        
        // sceneView上でタップした座標を検出
        let location = sender.location(in: sceneView)
        //現実座標取得
        let hitTestResult = sceneView.hitTest(location, types: .existingPlane)
        //アンラップ
        if let result = hitTestResult.first {
            let node = ZooViewController.collada2SCNNode(filepath: filepath)
            node.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    // collada2SCNNode
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
    
    // EAIntroView
    func zooIntroView(){
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
        thirdIntro.title = "動物をだすには？"
        thirdIntro.desc = """
        平面をタップすると動物が出現します
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
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
}

extension ZooViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

