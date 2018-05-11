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

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate  {
    
    var locationManager: CLLocationManager!

    // XMLParser のインスタンスを生成
    var parser = XMLParser()
    
    // 今回は item タグ内を取得。item で固定なので Stringクラスでインスタンスを生成
    var element = String()
    
    // 可変な辞書クラスNSMutableDictionary インスタンスを生成
    var elements = NSMutableDictionary()
    
    // enName タグ内の値を格納。値が変わるので、NSMutableString
    var enNameString = NSMutableString()
    
    // distance タグ内の値を格納。値が変わるので、NSMutableString
    var distanceString = NSMutableString()
    
    // rightAscension タグ内の値を格納。値が変わるので、NSMutableString
    var rightAscensionString = NSMutableString()
    
    // celestialDeclination タグ内の値を格納。値が変わるので、NSMutableString
    var celestialDeclinationString = NSMutableString()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在地を取得
        setupLocationManager()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
      
        sceneView.scene = SCNScene()
        let node = SCNNode(geometry: SCNSphere(radius: 0.05))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/hoshi.png")
        node.geometry?.materials = [material]
        node.position = SCNVector3(0,0,-10.0)
      
      
        let node2 = SCNNode(geometry: SCNSphere(radius: 0.05))
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/hosi4.jpg")
        node2.geometry?.materials = [material]
        node2.position = SCNVector3(0,6,-10.0)
      
      
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.scene.rootNode.addChildNode(node2)
        
        // xmlを解析(パース)
        let urlString:String = "http://www.walk-in-starrysky.com/star.do?cmd=detail&hrNo=6134"
        let url:URL = URL(string:urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
        print(elements)
    }
    
    // 開始タグ
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "star" {
            
            elements = NSMutableDictionary()
            elements = [:]
            enNameString = NSMutableString()
            enNameString = ""
            distanceString = NSMutableString()
            distanceString = ""
            rightAscensionString = NSMutableString()
            rightAscensionString = ""
            celestialDeclinationString = NSMutableString()
            celestialDeclinationString = ""
        }
    }
    
    // 開始タグと終了タグの間にデータが存在した時
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "enName"{
            
            enNameString.append(string)
            
        } else if element == "distance"{
            
            distanceString.append(string)
            
        } else if element == "rightAscension"{
            
            rightAscensionString.append(string)
            
        } else if element == "celestialDeclination"{
            
            celestialDeclinationString.append(string)
            
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
            
            // distanceString の中身が空でないなら
            if distanceString != "" {
                // elementsにキー: distance を付与して、 distanceString をセット
                elements.setObject(distanceString, forKey: "distance" as NSCopying)
            }
            
            // rightAscensionString の中身が空でないなら
            if rightAscensionString != "" {
                // elementsにキー: rightAscension を付与して、 rightAscensionString をセット
                elements.setObject(rightAscensionString, forKey: "rightAscension" as NSCopying)
            }
            
            // celestialDeclinationString の中身が空でないなら
            if celestialDeclinationString != "" {
                // elementsにキー: celestialDeclination を付与して、 celestialDeclinationString をセット
                elements.setObject(celestialDeclinationString, forKey: "celestialDeclination" as NSCopying)
            }
            
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
    
    //location
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
        
        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
