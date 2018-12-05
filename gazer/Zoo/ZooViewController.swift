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
import EAIntroView

class ZooViewController: UIViewController, ARSCNViewDelegate ,EAIntroDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var animalButton: UIButton!
    @IBOutlet weak var objectButton: UIButton!
    
    
    var zooSaveImage:UIImage! = nil
    
    @IBAction func pushCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            
            cameraButton.isHidden = true //ボタン非表示
            animalButton.isHidden = true
            objectButton.isHidden = true
            
            zooSaveImage = zooGetScreenShot()
            performSegue(withIdentifier: "prevPhoto", sender: nil)
            
            cameraButton.isHidden = false //ボタン表示
            animalButton.isHidden = false
            objectButton.isHidden = false
            
        }
        else{
            
            let alert = UIAlertController(title: "カメラへのアクセスが拒否されています。", message: "設定画面よりアクセスを許可してください。", preferredStyle:.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        }
    }
    
    // スワイプしたらメニュー画面戻る
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
        beforeMenu.modalTransitionStyle = .crossDissolve
        present(beforeMenu, animated: true, completion: nil)
    }
    // 動物選択画面
    @IBAction func openButton(_ sender: UIButton) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "ZooModalViewController")
        modalViewController?.modalPresentationStyle = .custom
        modalViewController?.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        present(modalViewController!, animated: true, completion: nil)
    }
    
    // オブジェクト選択画面
    @IBAction func objectOpenButton(_ sender: UIButton) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "ObjectModalViewController")
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
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapView))
        sceneView.addGestureRecognizer(longTap)
    }
    
    @objc func tapView(sender: UITapGestureRecognizer) {
        
        // AppDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let filepath = appDelegate.path
        
        // sceneView上でタップした座標を検出
        let location = sender.location(in: sceneView)
        //現実座標取得
        let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        //アンラップ
        if let result = hitTestResult.first {
            let node = ZooViewController.collada2SCNNode(filepath: filepath)
            node.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
            if let camera = sceneView.pointOfView {
                node.eulerAngles.y = camera.eulerAngles.y  // カメラのオイラー角と同じにする
            }
            sceneView.scene.rootNode.addChildNode(node)
        }
    }

    @objc func longTapView(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            // 開始は認知される
            print("LongTap")
        }
        else if sender.state == .ended {
            /*
            // sceneView上でタップした座標を検出
            let location = sender.location(in: sceneView)
            let targetNode = sceneView.hitTest(location, options: nil).first?.node
            */
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
        firstIntro.alpha = 0.9
        switch (UIScreen.main.nativeBounds.height) {
        case 2436:
            firstIntro.bgImage = UIImage(named:"wtAnimal10")
            break
        default:
            firstIntro.bgImage = UIImage(named:"wtAnimal")
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
    
    // Camera
    private func zooGetScreenShot() -> UIImage? {
        guard let view = self.view else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
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
    
    // PhotoPreViewControllerに受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photo = segue.destination as! PhotoPreViewController
        photo.screenImage = zooSaveImage
        photo.addImage = 1
    }
}

extension ZooViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

