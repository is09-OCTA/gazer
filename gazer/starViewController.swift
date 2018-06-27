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
import WSCoachMarksView

class starViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate,UIPageViewControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    var swipeView = UIImageView()

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
    
    // 星のサンプル座標(北斗七星)
    // let starPosition:[[Double]] = [[0,0,-10],[-0.3,1,-10],[-0.4,2,-10],[-1.5,3,-10],[-0.7,-0.7,-10],[0.1,-2,-10],[1.5,-1.6,-10]]

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
    
    // 星の構造体
    struct Star {
        let hipId: Int              // ヒッパルコス星表
        let enName: String          // 英語名
        let jpName: String          // 日本語名
        let rightAscension: Double  // 赤経
        let declination: Double     // 赤緯
        let magnitude: Double       // 等級
        let details: String         // 詳細説明
    }
    
    // 星のデータ配列
    let stars: [Star] = [
        (Star(hipId: 677, enName: "Alpheratz", jpName: "アルフェラッツ", rightAscension: 0.82317, declination: 29.527206, magnitude: 33.6, details: "" )),
        (Star(hipId: 746, enName: "Caph", jpName: "カフ", rightAscension: 0.91009, declination: 59.98227, magnitude: 59.89, details: "" )),
        (Star(hipId: 2081, enName: "Ankaa", jpName: "アンカ", rightAscension: 0.261687, declination: -42.18184237, magnitude: 42.14, details: "" )),
        (Star(hipId: 3179, enName: "Schedar", jpName: "シェダル", rightAscension: 0.403039, declination: 56.32147225, magnitude: 14.27, details: "" )),
        (Star(hipId: 3419, enName: "Diphda", jpName: "デネブ・カイトス", rightAscension: 0.433523, declination: -17.59121204, magnitude: 34.04, details: "" )),
        (Star(hipId: 4427, enName: "Gamma Cassiopeiae", jpName: "ツィー", rightAscension: 0.56425, declination: 60.433239, magnitude: 5.32, details: "" )),
        (Star(hipId: 5447, enName: "Mirach", jpName: "ミラク", rightAscension: 1.9438, declination: 35.3715206, magnitude: 16.36, details: "" )),
        (Star(hipId: 7588, enName: "Achernar", jpName: "アケルナル", rightAscension: 1.374275, declination: -57.14125, magnitude: 22.68, details: "" )),
        (Star(hipId: 9640, enName: "Almach", jpName: "アルマク", rightAscension: 2.35392, declination: 42.19475226, magnitude: 9.19, details: "" )),
        (Star(hipId: 9884, enName: "Hamal", jpName: "ハマル", rightAscension: 2.71029, declination: 23.27462, magnitude: 49.48, details: "" )),
        (Star(hipId: 11767, enName: "Polaris", jpName: "ポラリス", rightAscension: 2.314708, declination: 89.15509201, magnitude: 7.56, details: "" )),
        (Star(hipId: 14135, enName: "Menkar", jpName: "メンカル", rightAscension: 3.21678, declination: 4.5237253, magnitude: 14.82, details: "" )),
        (Star(hipId: 14576, enName: "Algol", jpName: "アルゴル", rightAscension: 3.81013, declination: 40.57203212, magnitude: 35.14, details: "" )),
        (Star(hipId: 15863, enName: "Mirphak", jpName: "ミルファク", rightAscension: 3.241935, declination: 49.51405182, magnitude: 5.51, details: "" )),
        (Star(hipId: 21421, enName: "Aldebaran", jpName: "アルデバラン", rightAscension: 4.35552, declination: 16.3035185, magnitude: 50.09, details: "" )),
        (Star(hipId: 24436, enName: "Rigel", jpName: "リゲル", rightAscension: 5.143227, declination: -8.125911, magnitude: 4.22, details: "" )),
        (Star(hipId: 24608, enName: "Capella A", jpName: "カペラ", rightAscension: 5.16413, declination: 45.5956571, magnitude: 77.29, details: "" )),
        (Star(hipId: 25336, enName: "Bellatrix", jpName: "ベラトリックス", rightAscension: 5.25787, declination: 6.2059164, magnitude: 13.42, details: "" )),
        (Star(hipId: 25428, enName: "El Nath", jpName: "エルナト", rightAscension: 5.26175, declination: 28.36283168, magnitude: 24.89, details: "" )),
        (Star(hipId: 25985, enName: "Arneb", jpName: "アルネブ", rightAscension: 5.324381, declination: -17.49203258, magnitude: 2.54, details: "" )),
        (Star(hipId: 26311, enName: "Alnilam", jpName: "アルニラム", rightAscension: 5.361281, declination: -1.126917, magnitude: 2.43, details: "" )),
        (Star(hipId: 26634, enName: "Phact", jpName: "ファクト", rightAscension: 5.393894, declination: -34.426626, magnitude: 12.16, details: "" )),
        (Star(hipId: 26727, enName: "Alnitak A", jpName: "アルニタク", rightAscension: 5.404552, declination: -1.5633317, magnitude: 3.99, details: "" )),
        (Star(hipId: 27366, enName: "Saiph", jpName: "サイフ", rightAscension: 5.474539, declination: -9.40106205, magnitude: 4.52, details: "" )),
        (Star(hipId: 27989, enName: "Betelgeuse", jpName: "ベテルギウス", rightAscension: 5.551029, declination: 7.2425358, magnitude: 7.63, details: "" )),
        (Star(hipId: 28380, enName: "Bogardus", jpName: "ボガルダス", rightAscension: 5.594324, declination: 37.1246262, magnitude: 18.83, details: "" )),
        (Star(hipId: 30324, enName: "Mirzam", jpName: "ムルジム", rightAscension: 6.224199, declination: -17.57213198, magnitude: 6.53, details: "" )),
        (Star(hipId: 30438, enName: "Canopus", jpName: "カノープス", rightAscension: 6.235709, declination: -52.41446-72, magnitude: 10.43, details: "" )),
        (Star(hipId: 31681, enName: "Alhena", jpName: "アルヘナ", rightAscension: 6.37427, declination: 16.2357919, magnitude: 31.12, details: "" )),
        (Star(hipId: 32349, enName: "Sirius A", jpName: "シリウス", rightAscension: 6.45925, declination: -16.42473-146, magnitude: 379.21, details: "" )),
        (Star(hipId: 33579, enName: "Adara", jpName: "アダーラ", rightAscension: 6.583755, declination: -28.58195151, magnitude: 7.57, details: "" )),
        (Star(hipId: 34444, enName: "Wezen", jpName: "ウェズン", rightAscension: 7.82349, declination: -26.23355184, magnitude: 1.82, details: "" )),
        (Star(hipId: 35904, enName: "Aludra", jpName: "アルドラ", rightAscension: 7.24571, declination: -29.1811224, magnitude: 1.02, details: "" )),
        (Star(hipId: 36850, enName: "Castor A", jpName: "カストル", rightAscension: 7.3436, declination: 31.53191196, magnitude: 63.27, details: "" )),
        (Star(hipId: 37279, enName: "Procyon", jpName: "プロキオン", rightAscension: 7.391854, declination: 5.133934, magnitude: 285.93, details: "" )),
        (Star(hipId: 37826, enName: "Pollux", jpName: "ポルックス", rightAscension: 7.451936, declination: 28.1347115, magnitude: 96.74, details: "" )),
        (Star(hipId: 39429, enName: "Zeta Puppis", jpName: "ナオス", rightAscension: 8.33507, declination: -40.0115221, magnitude: 2.33, details: "" )),
        (Star(hipId: 39953, enName: "Regor", jpName: "スハイル・ムーリフ", rightAscension: 8.93196, declination: -47.20118178, magnitude: 3.88, details: "" )),
        (Star(hipId: 41037, enName: "Avior", jpName: "アヴィオール", rightAscension: 8.223086, declination: -59.3034324, magnitude: 5.16, details: "" )),
        (Star(hipId: 42913, enName: "Koo She", jpName: "クー･シー", rightAscension: 8.44422, declination: -54.42308203, magnitude: 40.9, details: "" )),
        (Star(hipId: 44816, enName: "Lambda Velorum", jpName: "スハイル・ワズン", rightAscension: 9.75978, declination: -43.25574223, magnitude: 5.69, details: "" )),
        (Star(hipId: 45238, enName: "Miaplacidus", jpName: "ミアプラキドゥス", rightAscension: 9.131224, declination: -69.4329168, magnitude: 29.34, details: "" )),
        (Star(hipId: 45556, enName: "Aspidiske", jpName: "アスピディスケ", rightAscension: 9.17543, declination: -59.16309225, magnitude: 4.71, details: "" )),
        (Star(hipId: 45941, enName: "Kappa Velorum", jpName: "ほ座カッパ星", rightAscension: 9.22683, declination: -55.0385246, magnitude: 6.05, details: "" )),
        (Star(hipId: 46390, enName: "Alphard", jpName: "アルファルド", rightAscension: 9.273525, declination: -8.39313198, magnitude: 18.4, details: "" )),
        (Star(hipId: 49669, enName: "Regulus", jpName: "レグルス", rightAscension: 10.82246, declination: 11.5819135, magnitude: 42.09, details: "" )),
        (Star(hipId: 50583, enName: "Algieba", jpName: "アルギエバ", rightAscension: 10.195816, declination: 19.50307228, magnitude: 25.96, details: "" )),
        (Star(hipId: 53910, enName: "Merak", jpName: "メラク", rightAscension: 11.15039, declination: 56.22564235, magnitude: 41.07, details: "" )),
        (Star(hipId: 54061, enName: "Dubhe", jpName: "ドゥーベ", rightAscension: 11.34384, declination: 61.454187, magnitude: 26.38, details: "" )),
        (Star(hipId: 54872, enName: "Zosma", jpName: "ゾスマ", rightAscension: 11.14641, declination: 20.31265256, magnitude: 56.52, details: "" )),
        (Star(hipId: 57632, enName: "Denebola", jpName: "デネボラ", rightAscension: 11.49388, declination: 14.34204214, magnitude: 90.16, details: "" )),
        (Star(hipId: 58001, enName: "Phecda", jpName: "フェクダ", rightAscension: 11.534974, declination: 53.4141243, magnitude: 38.99, details: "" )),
        (Star(hipId: 59803, enName: "Gienah", jpName: "からす座ガンマ星", rightAscension: 12.154847, declination: -17.32311259, magnitude: 19.78, details: "" )),
        (Star(hipId: 60718, enName: "Acrux", jpName: "アクルックス", rightAscension: 12.263594, declination: -63.556614, magnitude: 10.17, details: "" )),
        (Star(hipId: 61084, enName: "Gacrux", jpName: "ガクルックス", rightAscension: 12.31993, declination: -57.6452163, magnitude: 37.09, details: "" )),
        (Star(hipId: 61359, enName: "Kraz", jpName: "クラズ", rightAscension: 12.342323, declination: -23.2347826, magnitude: 23.34, details: "" )),
        (Star(hipId: 62434, enName: "Mimosa", jpName: "ミモザ", rightAscension: 12.474332, declination: -59.4119413, magnitude: 9.25, details: "" )),
        (Star(hipId: 62956, enName: "Alioth", jpName: "アリオト", rightAscension: 12.54163, declination: 55.57354176, magnitude: 40.3, details: "" )),
        (Star(hipId: 65378, enName: "Mizar A", jpName: "ミザール", rightAscension: 13.235542, declination: 54.55315227, magnitude: 41.73, details: "" )),
        (Star(hipId: 65474, enName: "Spica", jpName: "スピカ", rightAscension: 13.25116, declination: -11.9405104, magnitude: 12.44, details: "" )),
        (Star(hipId: 66657, enName: "Epsilon Centauri", jpName: "バーダン", rightAscension: 13.395327, declination: -53.27589227, magnitude: 8.68, details: "" )),
        (Star(hipId: 67301, enName: "Alkaid", jpName: "ベネトナシュ", rightAscension: 13.473255, declination: 49.18479185, magnitude: 32.39, details: "" )),
        (Star(hipId: 68002, enName: "Zeta Centauri", jpName: "ケンタウルス座ゼータ星", rightAscension: 13.553243, declination: -47.17178255, magnitude: 8.48, details: "" )),
        (Star(hipId: 68702, enName: "Hadar", jpName: "ハダル", rightAscension: 14.34944, declination: -60.222276, magnitude: 6.21, details: "" )),
        (Star(hipId: 68933, enName: "Menkent", jpName: "メンケント", rightAscension: 14.64132, declination: -36.2273206, magnitude: 53.52, details: "" )),
        (Star(hipId: 69673, enName: "Arcturus", jpName: "アルクトゥルス", rightAscension: 14.154035, declination: 19.11142-4, magnitude: 88.85, details: "" )),
        (Star(hipId: 71352, enName: "Eta Centauri", jpName: "イータ・ケンタウリ", rightAscension: 14.353045, declination: -42.9279232, magnitude: 10.57, details: "" )),
        (Star(hipId: 71683, enName: "Alpha Centauri A", jpName: "リジル・ケンタウルス", rightAscension: 14.39409, declination: -60.5065-1, magnitude: 742.12, details: "" )),
        (Star(hipId: 71860, enName: "Alpha Lupi", jpName: "カッカブ", rightAscension: 14.415577, declination: -47.23173228, magnitude: 5.95, details: "" )),
        (Star(hipId: 72607, enName: "Kochab", jpName: "コカブ", rightAscension: 14.50424, declination: 74.9197208, magnitude: 25.79, details: "" )),
        (Star(hipId: 74785, enName: "Zubeneschamali", jpName: "ズベン・エス・カマリ", rightAscension: 15.1747, declination: -9.22583261, magnitude: 20.38, details: "" )),
        (Star(hipId: 76267, enName: "Alphecca", jpName: "ゲンマ", rightAscension: 15.344119, declination: 26.42537224, magnitude: 43.65, details: "" )),
        (Star(hipId: 77070, enName: "Unukalhai", jpName: "ウヌクアルハイ", rightAscension: 15.4416, declination: 6.25319263, magnitude: 44.54, details: "" )),
        (Star(hipId: 78401, enName: "Dschubba", jpName: "ジュバ", rightAscension: 16.02001, declination: -22.37178229, magnitude: 8.12, details: "" )),
        (Star(hipId: 78820, enName: "Acrab", jpName: "アクラブ", rightAscension: 16.52623, declination: -19.48194259, magnitude: 6.15, details: "" )),
        (Star(hipId: 80763, enName: "Antares", jpName: "アンタレス", rightAscension: 16.292447, declination: -26.2555109, magnitude: 5.4, details: "" )),
        (Star(hipId: 81377, enName: "Zeta Ophiuchi", jpName: "へびつかい座ゼータ星", rightAscension: 16.37953, declination: -10.3417254, magnitude: 7.12, details: "" )),
        (Star(hipId: 82273, enName: "Atria", jpName: "アトリア", rightAscension: 16.483987, declination: -69.1395192, magnitude: 7.85, details: "" )),
        (Star(hipId: 82396, enName: "Wei", jpName: "ウェイ", rightAscension: 16.501024, declination: -34.17334229, magnitude: 49.85, details: "" )),
        (Star(hipId: 85927, enName: "Shaula", jpName: "シャウラ", rightAscension: 17.333653, declination: -37.6135162, magnitude: 4.64, details: "" )),
        (Star(hipId: 86032, enName: "Ras Alhague", jpName: "ラス・アルハゲ", rightAscension: 17.3456, declination: 12.3338121, magnitude: 69.84, details: "" )),
        (Star(hipId: 86228, enName: "Girtab", jpName: "サルガス", rightAscension: 17.371913, declination: -42.59522186, magnitude: 11.99, details: "" )),
        (Star(hipId: 86670, enName: "Girtab", jpName: "ギルタブ", rightAscension: 17.422928, declination: -39.1477238, magnitude: 7.03, details: "" )),
        (Star(hipId: 87833, enName: "Etamin", jpName: "エルタニン", rightAscension: 17.563638, declination: 51.29202223, magnitude: 22.1, details: "" )),
        (Star(hipId: 90185, enName: "Kaus Australis", jpName: "カウス・アウストラリス", rightAscension: 18.241035, declination: -34.233518, magnitude: 22.55, details: "" )),
        (Star(hipId: 91262, enName: "Vega", jpName: "ベガ", rightAscension: 18.365619, declination: 38.465883, magnitude: 128.93, details: "" )),
        (Star(hipId: 92855, enName: "Nunki", jpName: "ヌンキ", rightAscension: 18.551592, declination: -26.17477206, magnitude: 14.54, details: "" )),
        (Star(hipId: 93506, enName: "Ascella", jpName: "アスケラ", rightAscension: 19.23672, declination: -29.5248426, magnitude: 36.61, details: "" )),
        (Star(hipId: 97649, enName: "Altair", jpName: "アルタイル", rightAscension: 19.504668, declination: 8.522677, magnitude: 194.44, details: "" )),
        (Star(hipId: 100453, enName: "Sadr", jpName: "サドル", rightAscension: 20.22137, declination: 40.15241224, magnitude: 2.14, details: "" )),
        (Star(hipId: 100751, enName: "Peacock", jpName: "ピーコック", rightAscension: 20.253885, declination: -56.4456191, magnitude: 17.8, details: "" )),
        (Star(hipId: 102098, enName: "Deneb", jpName: "デネブ", rightAscension: 20.412591, declination: 45.16492125, magnitude: 1.01, details: "" )),
        (Star(hipId: 102488, enName: "Gienah", jpName: "ギェナー", rightAscension: 20.461243, declination: 33.581025, magnitude: 45.26, details: "" )),
        (Star(hipId: 105199, enName: "Alderamin", jpName: "アルデラミン", rightAscension: 21.183458, declination: 62.3576244, magnitude: 66.84, details: "" )),
        (Star(hipId: 107315, enName: "Enif", jpName: "エニフ", rightAscension: 21.441114, declination: 9.523024, magnitude: 4.85, details: "" )),
        (Star(hipId: 109268, enName: "Alnair", jpName: "アルナイル", rightAscension: 22.81388, declination: -46.57382174, magnitude: 32.16, details: "" )),
        (Star(hipId: 112122, enName: "Beta Gruis", jpName: "グライド", rightAscension: 22.423993, declination: -46.5344213, magnitude: 19.17, details: "" )),
        (Star(hipId: 113368, enName: "Fomalhaut", jpName: "フォーマルハウト", rightAscension: 22.573883, declination: -29.37186116, magnitude: 130.08, details: "" )),
        (Star(hipId: 113881, enName: "Scheat", jpName: "シェアト", rightAscension: 23.34633, declination: 28.4568242, magnitude: 16.37, details: "" )),
        (Star(hipId: 113963, enName: "Markab", jpName: "マルカブ", rightAscension: 23.44562, declination: 15.12193249, magnitude: 23.36, details: "" ))
    ]
        
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
        
        // 星表示(仮)
        // setStar(starPosition: starPosition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // coachMarks表示
        //一度だけ実行したい処理メソッド
        
        //初回起動判定
        let ud = UserDefaults.standard
        if ud.bool(forKey: "firstLaunch") {
            
            // 初回起動時の処理
            let arrCouach = [
                [ "rect"    :  CGRect(x:0 , y:175 , width:375 , height:250),
                  "caption" :  "右にスワイプすると、　　メニューに戻れます",
                  "shape"   : "square",
                  ],
                ]
            let couach: WSCoachMarksView = WSCoachMarksView(frame: self.view.bounds, coachMarks: arrCouach)
            couach.maskColor = UIColor(white: 0.0, alpha: 0.65)
            self.view.addSubview(couach)

            couach.start()
            
            // 2回目以降の起動では「firstLaunch」のkeyをfalseに
            ud.set(false, forKey: "firstLaunch")
        }
        
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
            let starNode = SCNNode(geometry: SCNSphere(radius: 1))
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/hoshi.png")
            starNode.geometry?.materials = [material]
            starNode.position = SCNVector3(element[0],element[1],element[2])
            star.append(starNode)
            // 表示
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
        
        return [Double(direction)!, Double(altitude)!]
        
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
        var xyz: [Double] = [0, 0, 0]
        
        let theta = (90 - altitude) * (PI / 180)
        let phi = direction * (PI / 180)
        let r = 400.0
        
        xyz[2] = r * sin(theta) * cos(phi)
        xyz[0] = r * sin(theta) * sin(phi)
        xyz[1] = r * cos(theta)
        
        return xyz
        
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
}
