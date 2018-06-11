//
//  ViewController.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/04/25.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import SCLAlertView
// import WSCoachMarksView

class starViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate,UIPageViewControllerDelegate, UIGestureRecognizerDelegate{

    
    @IBOutlet var sceneView: ARSCNView!
    
    // スワイプしたらメニュー画面戻る
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
        let storyboard : UIStoryboard = self.storyboard!
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
        beforeMenu.modalTransitionStyle = .crossDissolve
        present(beforeMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func pushCamera(_ sender: Any) {
        let image = getScreenShot()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
       SCLAlertView().showSuccess("お知らせ", subTitle: "写真を保存しました！", closeButtonTitle: "OK")

    }
    
    // 位置情報
    var locationManager: CLLocationManager!
    
    var latitudeLocation: Double!
    var longitudeLocation: Double!
    var apiURL: URL!
    //星のサンプル座標
    let starPosition:[[Double]] = [[0,0,-10],[-0.3,1,-10],[-0.4,2,-10],[-1.5,3,-10],[-0.7,-0.7,-10],[0.1,-2,-10],[1.5,-1.6,-10]]

    // Date
    struct ReqDate {
        var yyyy: Int
        var MM: Int
        var dd: Int
        var HH: Int
        var mm: Int
        var ss: Int
    }
    
    // Area
    struct ReqArea {
        var latitude: Double    // 緯度
        var longitude: Double   // 経度
        var alfa: Double        // 赤経
        var delta: Double       // 赤緯
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        let f = self.view.bounds
        let arrCouach = [
            [ "rect"    :  CGRect(x:f.width - 84 , y:f.height - 38 , width:64, height:30),
              "caption" :  "（メッセージを個々に記入）",
              "shape"   : "square",
              ],
            ]
        let couach: WSCoachMarksView = WSCoachMarksView(frame: self.view.bounds, coachMarks: arrCouach)
        couach.maskColor = UIColor(white: 0.0, alpha: 0.65)
        self.view.addSubview(couach)
        couach.start()
 */
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        // 現在地を取得
        setupLocationManager()
        
        //星表示
        setStar(starPosition: starPosition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    // location
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            //locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        latitudeLocation = latitude
        longitudeLocation = longitude
        
        seturl(latitudeLocation: latitudeLocation!, longitudeLocation: longitudeLocation!)
    }
    
    func seturl (latitudeLocation: Double, longitudeLocation: Double) {
        
        /*:
         現在日時(年月日時分秒)を取得
         currentDate: 配列
         [年, 月, 日, 時, 分, 秒]
         */
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy,MM,dd,HH,mm,ss"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        let currentDate = format.string(from: date).split(separator: ",")
        
        let myDate = ReqDate(
            yyyy: Int(currentDate[0])!,
            MM: Int(currentDate[1])!,
            dd: Int(currentDate[2])!,
            HH: Int(currentDate[3])!,
            mm: Int(currentDate[4])!,
            ss: Int(currentDate[5])!
        )
        print(myDate)
        
        let myArea = ReqArea(
            latitude: latitudeLocation,
            longitude: longitudeLocation,
            alfa: 0,
            delta: 0
        )
        
        print(myArea)
    
    }
    
    //星情報設定&表示
    func setStar(starPosition: [[Double]]) -> Void {
        var star = [SCNNode]()
        self.sceneView.scene = SCNScene()
        for (index,element) in starPosition.enumerated() {
            // 表示する情報
            let starNode = SCNNode(geometry: SCNSphere(radius: 0.05))
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/hoshi.png")
            starNode.geometry?.materials = [material]
            starNode.position = SCNVector3(element[0],element[1],element[2])
            star.append(starNode)
            //表示
            self.sceneView.scene.rootNode.addChildNode(starNode)
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

    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
}
