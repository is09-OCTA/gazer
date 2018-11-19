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
import AVFoundation
import EAIntroView

class StarViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate,UIPageViewControllerDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate, EAIntroDelegate{
    
    @IBOutlet var sceneView: ARSCNView!

    // スワイプしたらメニュー画面戻る
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
        beforeMenu.modalTransitionStyle = .crossDissolve
        present(beforeMenu, animated: true, completion: nil)
        audioPlayer.stop()
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func pushCamera(_ sender: Any) {
        button.isHidden = true //ボタン非表示
        let image = starGetScreenShot()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
       SCLAlertView().showSuccess("お知らせ", subTitle: "写真を保存しました！", closeButtonTitle: "OK")
        button.isHidden = false //ボタン表示

    }

    //音楽インスタンス
    var audioPlayer: AVAudioPlayer!
    
    var textNode: SCNNode!
    
    // 位置情報
    var locationManager: CLLocationManager!
    var myHedingLabel:UILabel!
    var magneticHeading: CLLocationDirection!
    
    var latitudeLocation: Double!
    var longitudeLocation: Double!
    var apiURL: URL!

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
    
    // 定数
    let PI = 3.14159265358979
    let RAD = 180 / 3.14159265358979
    
    //星データ
    let stars = StarData().stars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starIntroView()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        // 現在地を取得
        setupLocationManager()

        // BGM再生
        playSound(name: "star_bgm")
        
        // 方位1
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            
            // Specifies the minimum amount of change in degrees needed for a heading service update (default: 1 degree)
            locationManager.headingFilter = 1
            
            // Specifies a physical device orientation from which heading calculation should be referenced
            locationManager.headingOrientation = .portrait
            
            locationManager.startUpdatingHeading()
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
    
    func setExposureTargetBias(_ bias: Float,
                               completionHandler handler: ((CMTime) -> Void)? = nil){
        return;
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        
        // ARKit 設定時にカメラからの画像が空で渡されるのでその場合は処理しない
        guard let cuptureImage = sceneView.session.currentFrame?.capturedImage else {
            return
        }
        
        // PixelBuffer を CIImage に変換しフィルターをかける
        let ciImage = CIImage.init(cvPixelBuffer: cuptureImage)
        let filter:CIFilter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        //filter.setValue(CIColor(red: 0.2, green: 0.2, blue: 0.2), forKey: "inputColor")
        filter.setValue(-0.2, forKey: kCIInputBrightnessKey)
        
        //　CIImage を CGImage に変換して背景に適応
        //　カメラ画像はホーム右のランドスケープの状態で画像が渡されるため、CGImagePropertyOrientation(rawValue: 6) でポートレートで正しい向きに表示されるよう変換
        let context = CIContext()
        let result = filter.outputImage!.oriented(CGImagePropertyOrientation(rawValue: 6)!)
        if let cgImage = context.createCGImage(result, from: result.extent) {
            sceneView.scene.background.contents = cgImage
        }
        
    }
    
    
    // EAIntroView
    func starIntroView(){
        // １ページ目
        let firstIntro = EAIntroPage()
        firstIntro.alpha = 0.9
        switch (UIScreen.main.nativeBounds.height) {
        case 2436:
            firstIntro.bgImage = UIImage(named:"wtStar10")
            break
        default:
            firstIntro.bgImage = UIImage(named:"wtStar")
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
            locationManager.stopUpdatingHeading()
        }
    }
//    方位2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //self.textField.text = "".appendingFormat("%.2f", newHeading.magneticHeading)
        //print(newHeading.magneticHeading)
        magneticHeading = newHeading.magneticHeading
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
//    方位2ここまで
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        latitudeLocation = latitude
        longitudeLocation = longitude
        
        seturl(latitudeLocation: latitudeLocation!, longitudeLocation: longitudeLocation!)
        locationManager.stopUpdatingLocation()
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
        
        let myArea = ReqArea(
            latitude: latitudeLocation,
            longitude: longitudeLocation,
            alfa: 0,
            delta: 0
        )
        
        setStar(starPosition: getStarInfo(date: myDate, area: myArea))
    }
    
    // 星情報設定&表示
    func setStar(starPosition: [[Double]]) -> Void {
        var star = [SCNNode]()
        self.sceneView.scene = SCNScene()
        for (index,element) in starPosition.enumerated() {
            
            // 表示する情報
            var starRadius = 1.0
            let material = SCNMaterial()
            let starRight = floor(stars[index].magnitude)
            if starRight <= 1 {
                material.diffuse.contents = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                starRadius = 1.4
            }else if starRight <= 2 {
                material.diffuse.contents = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
                starRadius = 1.2
            }else if starRight == 3 {
                material.diffuse.contents = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
            }else if starRight == 4 {
                material.diffuse.contents = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
                starRadius = 0.8
            }else{
                material.diffuse.contents = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
                starRadius = 0.6
            }
            let sphere = SCNSphere(radius: CGFloat(starRadius))
            sphere.isGeodesic = true
            sphere.segmentCount = 3
            let starNode = SCNNode(geometry: sphere)
            starNode.geometry?.materials = [material]
            starNode.position = SCNVector3(element[0],element[1],element[2])
            star.append(starNode)
            // 表示
            self.sceneView.scene.rootNode.addChildNode(starNode)
            
//            let camera = sceneView.pointOfView
            let str = stars[index].jpName
            let depth:CGFloat = 0.01
            let text = SCNText(string: str, extrusionDepth: depth)
            text.font = UIFont(name: "HiraginoSans-W3", size: 5)
            textNode = SCNNode(geometry: text)
            let (min, max) = (textNode.boundingBox)
            let x = CGFloat(max.x - min.x)
//            let y = CGFloat(max.y - min.y)
            //オブジェクト向き調整 -4で180度反転
            let z = element[4] * (Double.pi / 180) - 4
            let y = element[3] * (Double.pi / 180)
            textNode.eulerAngles = SCNVector3(y,z,0)
            textNode.position = SCNVector3((element[0] - Double(x)),element[1],element[2])
            sceneView.scene.rootNode.addChildNode(textNode)
        }
    }
    
    // Camera
    private func starGetScreenShot() -> UIImage? {
        guard let view = self.view else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // getStarInfo
    func getStarInfo(date: ReqDate, area: ReqArea) -> [[Double]] {
        let date = date
        var area = area
        
        var starsLocation: [[Double]] = []
        var starsXYZ: [[Double]] = []
        
        for (i, value) in stars.enumerated() {
            area.alfa = value.rightAscension
            area.delta = value.declination
            // 高度、方位に変換
            starsLocation.append(hcCalc(date: date, area: area))
            starsXYZ.append(getXYZ(altitude: starsLocation[i][1], direction: starsLocation[i][0]))
        }
        
        return starsXYZ
    }
    
    // hcCalc
    func hcCalc(date: ReqDate, area: ReqArea) -> Array<Double> {
        let HH = Double(date.HH / 24)
        let mm = Double(date.mm / 1440)
        let ss = Double(date.ss / 86400)
        let mjd = calcMJD(yyyy: date.yyyy, MM: date.MM, dd: date.dd) + HH + mm + ss - 0.375
        
        let d = 0.671262 + 1.002737909 * (mjd - 40000) + area.longitude / 360
        let lst = 2 * PI * (d - floor(d))
        
        let slat = sin(area.latitude / RAD)
        let clat = cos(area.latitude / RAD)
        let ra = 15 * area.alfa / RAD
        let dc = area.delta / RAD
        let ha = lst - ra
        let xs = sin(dc) * slat + cos(dc) * clat * cos(ha)
        var h = asin(xs)
        let s = cos(dc) * sin(ha)
        let c = cos(dc) * slat * cos(ha) - sin(dc) * clat
        var a: Double
        
        if c < 0 {
            a = atan(s / c) + PI
        } else if (c > 0 && s <= 0) {
            a = atan(s / c) + 2 * PI
        } else {
            a = atan(s / c)
        }
        if h == 0 {
            h = 0.00001
        }
        
        a = a * RAD
        h = h * RAD
        let rt = tan((h + 8.6 / (h + 4.4)) / RAD)
        h = h + 0.0167 / rt
        let sa = "" + String(a)
        let sh = "" + String(h)
        
        let direction = sa[..<sa.index(sa.startIndex, offsetBy: 7)]
        let altitude = sh[..<sh.index(sh.startIndex, offsetBy: 6)]
        
        if Double(direction)! + 180.0 + Double(magneticHeading) < 360 {
        
            return [Double(direction)! + 180 + Double(magneticHeading), Double(altitude)!]
        }else{
            return [Double(direction)! - 180 + Double(magneticHeading) , Double(altitude)!]
        }
    }
    
    // calcMJD
    func calcMJD(yyyy: Int, MM: Int, dd: Int) -> Double {
        var y: Int
        var m: Int
        
        if MM <= 2 {
            y = yyyy - 1
            m = MM + 12
        } else {
            y = yyyy
            m = MM
        }
        
        var ret = floor(365.25 * Double(y)) + floor(Double(y) / 400) - floor(Double(y) / 100)
        let tmp = floor(30.59 * (Double(m) - 2)) * Double(dd)
        ret = ret + (tmp - 678912)
        
        return ret
    }
    
    // getXYZ
    func getXYZ(altitude: Double, direction: Double) -> Array<Double> {
        var xyz: [Double] = [0, 0, 0, 0, 0]
        
        let theta = (90 - altitude) * (PI / 180)
        let phi = direction * (PI / 180)
        let r = 400.0
        
        xyz[2] = r * sin(theta) * cos(phi)
        xyz[0] = r * sin(theta) * sin(phi)
        xyz[1] = r * cos(theta)
        xyz[3] = altitude
        xyz[4] = direction
        
        return xyz
        
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
}
