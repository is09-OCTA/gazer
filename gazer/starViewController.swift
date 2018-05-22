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

class starViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate,UIPageViewControllerDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {//スワイプしたらメニュー画面戻る
        let storyboard : UIStoryboard = self.storyboard!
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"manu")
        present(beforeMenu, animated: true, completion: nil)
    }
    

    @IBAction func pushCamera(_ sender: Any) {
        let image = getScreenShot()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    // 位置情報
    var locationManager: CLLocationManager!
    
    // XMLParser のインスタンスを生成
    var parser = XMLParser()
    
    // テーブル内の列を可変な配列クラス(要素数を追加、挿入、削除など変更できる) NSMutableArrayのインスタンスを生成
    var rows = NSMutableArray()
    
    // 今回は star タグ内を取得。star で固定なので Stringクラスでインスタンスを生成
    var element = String()
    
    // 可変な辞書クラスNSMutableDictionary インスタンスを生成
    var elements = NSMutableDictionary()
    
    /*: 取得したいタグ内の値を格納
     enName: 星名(英字)
     visualGradeFrom: 実視等級(少ないほど明るい)
     direction: 方位(南を0°として西回りに360°まで)
     altitude: 高度(0°~90°)
     */
    
    var enNameString = NSMutableString()
    var visualGradeFromString = NSMutableString()
    var directionString = NSMutableString()
    var altitudeString = NSMutableString()
    
    var latitudeLocation: Double!
    var longitudeLocation: Double!
    var apiURL: URL!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        // 列の数を初期化
        rows = []
        
        // 現在地を取得
        setupLocationManager()

        // 表示する情報
        self.sceneView.scene = SCNScene()
        let node = SCNNode(geometry: SCNSphere(radius: 0.05))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/hoshi.png")
        node.geometry?.materials = [material]
        node.position = SCNVector3(0,5,-10.0)
      
        let node2 = SCNNode(geometry: SCNSphere(radius: 0.05))
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/hosi4.jpg")
        node2.geometry?.materials = [material]
        node2.position = SCNVector3(0,0,-10.0)
      
        // 表示
        self.sceneView.scene.rootNode.addChildNode(node)
        self.sceneView.scene.rootNode.addChildNode(node2)
        
    }
    
    // 開始タグ
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "star" {
            
            elements = NSMutableDictionary()
            elements = [:]
            
            enNameString = NSMutableString()
            enNameString = ""
            visualGradeFromString = NSMutableString()
            visualGradeFromString = ""
            directionString = NSMutableString()
            directionString = ""
            altitudeString = NSMutableString()
            altitudeString = ""
        }
    }
    
    // 開始タグと終了タグの間にデータが存在した時
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "enName"{
            
            enNameString.append(string)
            
        } else if element == "visualGradeFrom"{
            
            visualGradeFromString.append(string)
            
        } else if element == "direction"{
            
            directionString.append(string)
            
        } else if element == "altitude"{
            
            altitudeString.append(string)
            
        }
    }
    
    // 終了タグ
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // 要素 star だったら
        if elementName == "star"{
            
            // enNameString の中身が空でないなら
            if enNameString != "" {
                // elementsにキー: title を付与して、titleString をセット
                elements.setObject(enNameString, forKey: "enName" as NSCopying)
            }
            
            // visualGradeFromString の中身が空でないなら
            if visualGradeFromString != "" {
                // elementsにキー: visualGradeFrom を付与して、 visualGradeFromString をセット
                elements.setObject(visualGradeFromString, forKey: "visualGradeFrom" as NSCopying)
            }
            
            // directionString の中身が空でないなら
            if directionString != "" {
                // elementsにキー: direction を付与して、 directionString をセット
                elements.setObject(directionString, forKey: "direction" as NSCopying)
            }
            
            // altitudeString の中身が空でないなら
            if altitudeString != "" {
                // elementsにキー: altitude を付与して、 altitudeString をセット
                elements.setObject(altitudeString, forKey: "altitude" as NSCopying)
            }
            
            // rowsの中にelementsを加える
            rows.add(elements)
            
        }
        
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        latitudeLocation = latitude
        longitudeLocation = longitude
        
        seturl(latiudeLocation: latitudeLocation!, longitudeLocation: longitudeLocation!)
   
    }
    
    func seturl (latiudeLocation: Double, longitudeLocation: Double) {
        
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
        
        // 現在日時、位置情報(仮)を用いてURLを生成
        let urlString:String = "http://www.walk-in-starrysky.com/star.do?cmd=display&year=\(currentDate[0])&month=\(currentDate[1])&day=\(currentDate[2])&hour=\(currentDate[3])&minute=\(currentDate[4])&second=\(currentDate[5])&latitude=\(latiudeLocation)&longitude=\(longitudeLocation)"
        let url:URL = URL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!  // 日本語入りStringをURLに変換
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
        apiURL = url
        
        // 作成したURLを表示
        print(url)
        
        // 取得した星の情報を表示
        for value in rows {
            print(value)
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
