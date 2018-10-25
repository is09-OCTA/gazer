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

class starViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, XMLParserDelegate,UIPageViewControllerDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate, EAIntroDelegate{
    
    @IBOutlet var sceneView: ARSCNView!

    // スワイプしたらメニュー画面戻る
    @IBAction func retunMenuSwipe(_ sender: UISwipeGestureRecognizer) {
        let storyboard : UIStoryboard = self.storyboard!
        let beforeMenu = storyboard.instantiateViewController(withIdentifier:"menu")
        beforeMenu.modalTransitionStyle = .crossDissolve
        present(beforeMenu, animated: true, completion: nil)
        audioPlayer.stop()
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func pushCamera(_ sender: Any) {
        button.isHidden = true //ボタン非表示
        let image = getScreenShot()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
       SCLAlertView().showSuccess("お知らせ", subTitle: "写真を保存しました！", closeButtonTitle: "OK")
        button.isHidden = false //ボタン表示

    }

    //音楽インスタンス
    var audioPlayer: AVAudioPlayer!
    
    // 位置情報
    var locationManager: CLLocationManager!
    
    var latitudeLocation: Double!
    var longitudeLocation: Double!
    var apiURL: URL!
    
    // 星のサンプル座標(北斗七星)
    //let starPosition:[[Double]] = [[0,0,-10],[-0.3,1,-10],[-0.4,2,-10],[-1.5,3,-10],[-0.7,-0.7,-10],[0.1,-2,-10],[1.5,-1.6,-10]]

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
        (Star(hipId: 677, enName: "Alpheratz", jpName: "アルフェラッツ", rightAscension: 0.82317, declination: 29.527, magnitude: 2.07, details: "" )),
        (Star(hipId: 746, enName: "Caph", jpName: "カフ", rightAscension: 0.91009, declination: 59.98, magnitude: 2.28, details: "" )),
        (Star(hipId: 765, enName: "", jpName: "", rightAscension: 0.92454, declination: -45.44492, magnitude: 3.88, details: "" )),
        (Star(hipId: 1067, enName: "", jpName: "", rightAscension: 0.131415, declination: 15.111, magnitude: 2.83, details: "" )),
        (Star(hipId: 1562, enName: "", jpName: "", rightAscension: 0.192568, declination: -8.49258, magnitude: 3.56, details: "" )),
        (Star(hipId: 1599, enName: "", jpName: "", rightAscension: 0.20191, declination: -64.52394, magnitude: 4.23, details: "" )),
        (Star(hipId: 1645, enName: "", jpName: "", rightAscension: 0.203586, declination: 8.11249, magnitude: 5.38, details: "" )),
        (Star(hipId: 2021, enName: "", jpName: "", rightAscension: 0.25392, declination: -77.15181, magnitude: 2.82, details: "" )),
        (Star(hipId: 2072, enName: "", jpName: "", rightAscension: 0.261212, declination: -43.40477, magnitude: 3.93, details: "" )),
        (Star(hipId: 2081, enName: "Ankaa", jpName: "アンカ", rightAscension: 0.261687, declination: -42.18184, magnitude: 2.4, details: "" )),
        (Star(hipId: 2484, enName: "", jpName: "", rightAscension: 0.313256, declination: -62.57291, magnitude: 4.36, details: "" )),
        (Star(hipId: 3092, enName: "", jpName: "", rightAscension: 0.39196, declination: 30.51404, magnitude: 3.27, details: "" )),
        (Star(hipId: 3179, enName: "Schedar", jpName: "シェダル", rightAscension: 0.403039, declination: 56.32147, magnitude: 2.24, details: "" )),
        (Star(hipId: 3419, enName: "Diphda", jpName: "デネブ・カイトス", rightAscension: 0.433523, declination: -17.59121, magnitude: 2.04, details: "" )),
        (Star(hipId: 3760, enName: "", jpName: "", rightAscension: 0.481734, declination: 7.17597, magnitude: 5.92, details: "" )),
        (Star(hipId: 3881, enName: "", jpName: "", rightAscension: 0.494883, declination: 41.4442, magnitude: 4.53, details: "" )),
        (Star(hipId: 4427, enName: "Gamma Cassiopeiae", jpName: "ツィー", rightAscension: 0.56425, declination: 60.433, magnitude: 2.15, details: "" )),
        (Star(hipId: 4436, enName: "", jpName: "", rightAscension: 0.56451, declination: 38.29573, magnitude: 3.86, details: "" )),
        (Star(hipId: 4577, enName: "", jpName: "", rightAscension: 0.583635, declination: -29.21269, magnitude: 4.3, details: "" )),
        (Star(hipId: 4889, enName: "", jpName: "", rightAscension: 1.24909, declination: 31.48156, magnitude: 5.5, details: "" )),
        (Star(hipId: 4906, enName: "", jpName: "", rightAscension: 1.25666, declination: 7.53243, magnitude: 4.27, details: "" )),
        (Star(hipId: 5165, enName: "", jpName: "", rightAscension: 1.6511, declination: -46.4366, magnitude: 3.32, details: "" )),
        (Star(hipId: 5348, enName: "", jpName: "", rightAscension: 1.82306, declination: -55.1445, magnitude: 3.94, details: "" )),
        (Star(hipId: 5364, enName: "", jpName: "", rightAscension: 1.83526, declination: -10.10549, magnitude: 3.46, details: "" )),
        (Star(hipId: 5447, enName: "Mirach", jpName: "ミラク", rightAscension: 1.9438, declination: 35.3715, magnitude: 2.07, details: "" )),
        (Star(hipId: 5742, enName: "", jpName: "", rightAscension: 1.134494, declination: 24.3516, magnitude: 4.67, details: "" )),
        (Star(hipId: 6193, enName: "", jpName: "", rightAscension: 1.192798, declination: 27.15507, magnitude: 4.74, details: "" )),
        (Star(hipId: 6537, enName: "", jpName: "", rightAscension: 1.24145, declination: -8.10579, magnitude: 3.6, details: "" )),
        (Star(hipId: 6686, enName: "", jpName: "", rightAscension: 1.25486, declination: 60.1475, magnitude: 2.66, details: "" )),
        (Star(hipId: 6867, enName: "", jpName: "", rightAscension: 1.282194, declination: -43.1938, magnitude: 3.41, details: "" )),
        (Star(hipId: 7007, enName: "", jpName: "", rightAscension: 1.301094, declination: 6.8382, magnitude: 4.84, details: "" )),
        (Star(hipId: 7083, enName: "", jpName: "", rightAscension: 1.311498, declination: -49.4231, magnitude: 3.93, details: "" )),
        (Star(hipId: 7097, enName: "", jpName: "", rightAscension: 1.312899, declination: 15.2045, magnitude: 3.62, details: "" )),
        (Star(hipId: 7588, enName: "Achernar", jpName: "アケルナル", rightAscension: 1.374275, declination: -57.1412, magnitude: 0.45, details: "" )),
        (Star(hipId: 7884, enName: "", jpName: "", rightAscension: 1.412591, declination: 5.29154, magnitude: 4.45, details: "" )),
        (Star(hipId: 8102, enName: "", jpName: "", rightAscension: 1.44513, declination: -15.56224, magnitude: 3.49, details: "" )),
        (Star(hipId: 8198, enName: "", jpName: "", rightAscension: 1.452359, declination: 9.9275, magnitude: 4.26, details: "" )),
        (Star(hipId: 8645, enName: "", jpName: "", rightAscension: 1.512761, declination: -10.2058, magnitude: 3.74, details: "" )),
        (Star(hipId: 8796, enName: "", jpName: "", rightAscension: 1.5349, declination: 29.34458, magnitude: 3.42, details: "" )),
        (Star(hipId: 8832, enName: "", jpName: "", rightAscension: 1.533177, declination: 19.17387, magnitude: 3.88, details: "" )),
        (Star(hipId: 8833, enName: "", jpName: "", rightAscension: 1.533334, declination: 3.11149, magnitude: 4.61, details: "" )),
        (Star(hipId: 8837, enName: "", jpName: "", rightAscension: 1.533882, declination: -46.1888, magnitude: 4.39, details: "" )),
        (Star(hipId: 8886, enName: "", jpName: "", rightAscension: 1.542368, declination: 63.40125, magnitude: 3.35, details: "" )),
        (Star(hipId: 8903, enName: "", jpName: "", rightAscension: 1.543835, declination: 20.48299, magnitude: 2.64, details: "" )),
        (Star(hipId: 9007, enName: "", jpName: "", rightAscension: 1.555683, declination: -51.36345, magnitude: 3.69, details: "" )),
        (Star(hipId: 9236, enName: "", jpName: "", rightAscension: 1.584587, declination: -61.34117, magnitude: 2.86, details: "" )),
        (Star(hipId: 9487, enName: "", jpName: "", rightAscension: 2.228, declination: 2.45495, magnitude: 3.82, details: "" )),
        (Star(hipId: 9640, enName: "Almach", jpName: "アルマク", rightAscension: 2.35392, declination: 42.19475, magnitude: 2.1, details: "" )),
        (Star(hipId: 9884, enName: "Hamal", jpName: "ハマル", rightAscension: 2.71029, declination: 23.2746, magnitude: 2.01, details: "" )),
        (Star(hipId: 10064, enName: "", jpName: "", rightAscension: 2.93252, declination: 34.59146, magnitude: 3, details: "" )),
        (Star(hipId: 10324, enName: "", jpName: "", rightAscension: 2.131, declination: 8.50483, magnitude: 4.36, details: "" )),
        (Star(hipId: 10559, enName: "", jpName: "", rightAscension: 2.15563, declination: 33.21323, magnitude: 5.25, details: "" )),
        (Star(hipId: 10602, enName: "", jpName: "", rightAscension: 2.16305, declination: -51.30436, magnitude: 3.56, details: "" )),
        (Star(hipId: 10826, enName: "", jpName: "", rightAscension: 2.192079, declination: -2.58374, magnitude: 6.47, details: "" )),
        (Star(hipId: 11001, enName: "", jpName: "", rightAscension: 2.214502, declination: -68.39339, magnitude: 4.08, details: "" )),
        (Star(hipId: 11345, enName: "", jpName: "", rightAscension: 2.255701, declination: -12.17256, magnitude: 4.88, details: "" )),
        (Star(hipId: 11407, enName: "", jpName: "", rightAscension: 2.26591, declination: -47.42138, magnitude: 4.24, details: "" )),
        (Star(hipId: 11484, enName: "", jpName: "", rightAscension: 2.28952, declination: 8.27363, magnitude: 4.3, details: "" )),
        (Star(hipId: 11767, enName: "Polaris", jpName: "ポラリス", rightAscension: 2.314708, declination: 89.15509, magnitude: 1.97, details: "" )),
        (Star(hipId: 11783, enName: "", jpName: "", rightAscension: 2.32528, declination: -15.14396, magnitude: 4.74, details: "" )),
        (Star(hipId: 12093, enName: "", jpName: "", rightAscension: 2.355249, declination: 5.35359, magnitude: 4.87, details: "" )),
        (Star(hipId: 12387, enName: "", jpName: "", rightAscension: 2.392895, declination: 0.19427, magnitude: 4.08, details: "" )),
        (Star(hipId: 12390, enName: "", jpName: "", rightAscension: 2.393373, declination: -11.52177, magnitude: 4.83, details: "" )),
        (Star(hipId: 12394, enName: "", jpName: "", rightAscension: 2.393522, declination: -68.161, magnitude: 4.12, details: "" )),
        (Star(hipId: 12413, enName: "", jpName: "", rightAscension: 2.394792, declination: -42.53299, magnitude: 4.74, details: "" )),
        (Star(hipId: 12484, enName: "", jpName: "", rightAscension: 2.403958, declination: -54.32597, magnitude: 5.21, details: "" )),
        (Star(hipId: 12486, enName: "", jpName: "", rightAscension: 2.403993, declination: -39.51191, magnitude: 4.11, details: "" )),
        (Star(hipId: 12706, enName: "", jpName: "", rightAscension: 2.431812, declination: 3.14102, magnitude: 3.47, details: "" )),
        (Star(hipId: 12770, enName: "", jpName: "", rightAscension: 2.44735, declination: -13.51312, magnitude: 4.24, details: "" )),
        (Star(hipId: 12828, enName: "", jpName: "", rightAscension: 2.445637, declination: 10.6512, magnitude: 4.27, details: "" )),
        (Star(hipId: 12843, enName: "", jpName: "", rightAscension: 2.45598, declination: -18.34215, magnitude: 4.47, details: "" )),
        (Star(hipId: 13147, enName: "", jpName: "", rightAscension: 2.49536, declination: -32.24226, magnitude: 4.45, details: "" )),
        (Star(hipId: 13209, enName: "", jpName: "", rightAscension: 2.495899, declination: 27.15388, magnitude: 3.61, details: "" )),
        (Star(hipId: 13254, enName: "", jpName: "", rightAscension: 2.503491, declination: 38.1981, magnitude: 4.22, details: "" )),
        (Star(hipId: 13268, enName: "", jpName: "", rightAscension: 2.504179, declination: 55.53439, magnitude: 3.77, details: "" )),
        (Star(hipId: 13701, enName: "", jpName: "", rightAscension: 2.56256, declination: -8.53514, magnitude: 3.89, details: "" )),
        (Star(hipId: 13847, enName: "", jpName: "", rightAscension: 2.581572, declination: -40.1817, magnitude: 2.88, details: "" )),
        (Star(hipId: 13954, enName: "", jpName: "", rightAscension: 2.59429, declination: 8.54266, magnitude: 4.71, details: "" )),
        (Star(hipId: 14135, enName: "Menkar", jpName: "メンカル", rightAscension: 3.21678, declination: 4.5237, magnitude: 2.54, details: "" )),
        (Star(hipId: 14146, enName: "", jpName: "", rightAscension: 3.22359, declination: -23.37276, magnitude: 4.08, details: "" )),
        (Star(hipId: 14240, enName: "", jpName: "", rightAscension: 3.3369, declination: -59.44154, magnitude: 5.12, details: "" )),
        (Star(hipId: 14328, enName: "", jpName: "", rightAscension: 3.44779, declination: 53.30232, magnitude: 2.91, details: "" )),
        (Star(hipId: 14354, enName: "", jpName: "", rightAscension: 3.5105, declination: 38.50259, magnitude: 3.32, details: "" )),
        (Star(hipId: 14576, enName: "Algol", jpName: "アルゴル", rightAscension: 3.81013, declination: 40.57203, magnitude: 2.09, details: "" )),
        (Star(hipId: 14879, enName: "", jpName: "", rightAscension: 3.12428, declination: -28.59208, magnitude: 3.8, details: "" )),
        (Star(hipId: 15197, enName: "", jpName: "", rightAscension: 3.155003, declination: -8.49114, magnitude: 4.8, details: "" )),
        (Star(hipId: 15474, enName: "", jpName: "", rightAscension: 3.193097, declination: -21.45286, magnitude: 3.7, details: "" )),
        (Star(hipId: 15510, enName: "", jpName: "", rightAscension: 3.195322, declination: -43.4176, magnitude: 4.26, details: "" )),
        (Star(hipId: 15863, enName: "Mirphak", jpName: "ミルファク", rightAscension: 3.241935, declination: 49.51405, magnitude: 1.79, details: "" )),
        (Star(hipId: 15900, enName: "", jpName: "", rightAscension: 3.244884, declination: 9.1446, magnitude: 3.61, details: "" )),
        (Star(hipId: 16228, enName: "", jpName: "", rightAscension: 3.29413, declination: 59.56252, magnitude: 4.21, details: "" )),
        (Star(hipId: 16537, enName: "", jpName: "", rightAscension: 3.325642, declination: -9.27299, magnitude: 3.72, details: "" )),
        (Star(hipId: 16611, enName: "", jpName: "", rightAscension: 3.334725, declination: -21.37581, magnitude: 4.26, details: "" )),
        (Star(hipId: 17358, enName: "", jpName: "", rightAscension: 3.425548, declination: 47.47156, magnitude: 3.01, details: "" )),
        (Star(hipId: 17378, enName: "", jpName: "", rightAscension: 3.431496, declination: -9.45547, magnitude: 3.52, details: "" )),
        (Star(hipId: 17440, enName: "", jpName: "", rightAscension: 3.441155, declination: -64.48255, magnitude: 3.84, details: "" )),
        (Star(hipId: 17448, enName: "", jpName: "", rightAscension: 3.441913, declination: 32.17178, magnitude: 3.84, details: "" )),
        (Star(hipId: 17651, enName: "", jpName: "", rightAscension: 3.465099, declination: -23.14544, magnitude: 4.22, details: "" )),
        (Star(hipId: 17678, enName: "", jpName: "", rightAscension: 3.471423, declination: -74.14213, magnitude: 3.26, details: "" )),
        (Star(hipId: 17797, enName: "", jpName: "", rightAscension: 3.483582, declination: -37.37125, magnitude: 4.3, details: "" )),
        (Star(hipId: 17847, enName: "", jpName: "", rightAscension: 3.49973, declination: 24.3127, magnitude: 3.62, details: "" )),
        (Star(hipId: 17874, enName: "", jpName: "", rightAscension: 3.492728, declination: -36.124, magnitude: 4.17, details: "" )),
        (Star(hipId: 17959, enName: "", jpName: "", rightAscension: 3.502148, declination: 71.19565, magnitude: 4.59, details: "" )),
        (Star(hipId: 18246, enName: "", jpName: "", rightAscension: 3.54792, declination: 31.5312, magnitude: 2.84, details: "" )),
        (Star(hipId: 18505, enName: "", jpName: "", rightAscension: 3.572544, declination: 63.4201, magnitude: 4.95, details: "" )),
        (Star(hipId: 18532, enName: "", jpName: "", rightAscension: 3.575122, declination: 40.037, magnitude: 2.9, details: "" )),
        (Star(hipId: 18597, enName: "", jpName: "", rightAscension: 3.584474, declination: -61.245, magnitude: 4.56, details: "" )),
        (Star(hipId: 18614, enName: "", jpName: "", rightAscension: 3.58579, declination: 35.47277, magnitude: 3.98, details: "" )),
        (Star(hipId: 18724, enName: "", jpName: "", rightAscension: 4.04082, declination: 12.29254, magnitude: 3.41, details: "" )),
        (Star(hipId: 19747, enName: "", jpName: "", rightAscension: 4.148, declination: -42.17379, magnitude: 3.85, details: "" )),
        (Star(hipId: 19780, enName: "", jpName: "", rightAscension: 4.142543, declination: -62.28263, magnitude: 3.33, details: "" )),
        (Star(hipId: 19893, enName: "", jpName: "", rightAscension: 4.16149, declination: -51.29135, magnitude: 4.26, details: "" )),
        (Star(hipId: 19921, enName: "", jpName: "", rightAscension: 4.162908, declination: -59.1863, magnitude: 4.44, details: "" )),
        (Star(hipId: 20042, enName: "", jpName: "", rightAscension: 4.175362, declination: -33.4754, magnitude: 3.55, details: "" )),
        (Star(hipId: 20205, enName: "", jpName: "", rightAscension: 4.194753, declination: 15.37397, magnitude: 3.65, details: "" )),
        (Star(hipId: 20455, enName: "", jpName: "", rightAscension: 4.225603, declination: 17.32333, magnitude: 3.77, details: "" )),
        (Star(hipId: 20535, enName: "", jpName: "", rightAscension: 4.24217, declination: -34.112, magnitude: 3.97, details: "" )),
        (Star(hipId: 20648, enName: "", jpName: "", rightAscension: 4.252932, declination: 17.55408, magnitude: 4.3, details: "" )),
        (Star(hipId: 20889, enName: "", jpName: "", rightAscension: 4.283693, declination: 19.10499, magnitude: 3.53, details: "" )),
        (Star(hipId: 20894, enName: "", jpName: "", rightAscension: 4.283967, declination: 15.52154, magnitude: 3.4, details: "" )),
        (Star(hipId: 21060, enName: "", jpName: "", rightAscension: 4.30501, declination: -44.57135, magnitude: 5.07, details: "" )),
        (Star(hipId: 21281, enName: "", jpName: "", rightAscension: 4.335972, declination: -55.242, magnitude: 3.3, details: "" )),
        (Star(hipId: 21393, enName: "", jpName: "", rightAscension: 4.353307, declination: -30.33443, magnitude: 3.81, details: "" )),
        (Star(hipId: 21421, enName: "Aldebaran", jpName: "アルデバラン", rightAscension: 4.35552, declination: 16.30351, magnitude: 0.87, details: "" )),
        (Star(hipId: 21444, enName: "", jpName: "", rightAscension: 4.361914, declination: -3.2188, magnitude: 3.93, details: "" )),
        (Star(hipId: 21594, enName: "", jpName: "", rightAscension: 4.381087, declination: -14.18129, magnitude: 3.86, details: "" )),
        (Star(hipId: 21770, enName: "", jpName: "", rightAscension: 4.403382, declination: -41.51489, magnitude: 4.44, details: "" )),
        (Star(hipId: 21861, enName: "", jpName: "", rightAscension: 4.42345, declination: -37.8412, magnitude: 5.04, details: "" )),
        (Star(hipId: 21881, enName: "", jpName: "", rightAscension: 4.42147, declination: 22.57251, magnitude: 4.27, details: "" )),
        (Star(hipId: 21949, enName: "", jpName: "", rightAscension: 4.43395, declination: -70.5552, magnitude: 5.53, details: "" )),
        (Star(hipId: 22109, enName: "", jpName: "", rightAscension: 4.453014, declination: -3.15166, magnitude: 4.01, details: "" )),
        (Star(hipId: 22449, enName: "", jpName: "", rightAscension: 4.495014, declination: 6.57405, magnitude: 3.19, details: "" )),
        (Star(hipId: 22509, enName: "", jpName: "", rightAscension: 4.503672, declination: 8.549, magnitude: 4.35, details: "" )),
        (Star(hipId: 22549, enName: "", jpName: "", rightAscension: 4.511237, declination: 5.36184, magnitude: 3.68, details: "" )),
        (Star(hipId: 22701, enName: "", jpName: "", rightAscension: 4.525368, declination: -5.2799, magnitude: 4.36, details: "" )),
        (Star(hipId: 22730, enName: "", jpName: "", rightAscension: 4.532276, declination: 2.30298, magnitude: 5.33, details: "" )),
        (Star(hipId: 22783, enName: "", jpName: "", rightAscension: 4.54301, declination: 66.20336, magnitude: 4.26, details: "" )),
        (Star(hipId: 22845, enName: "", jpName: "", rightAscension: 4.54537, declination: 10.941, magnitude: 4.64, details: "" )),
        (Star(hipId: 23015, enName: "", jpName: "", rightAscension: 4.565962, declination: 33.9581, magnitude: 2.69, details: "" )),
        (Star(hipId: 23123, enName: "", jpName: "", rightAscension: 4.58329, declination: 1.42505, magnitude: 4.47, details: "" )),
        (Star(hipId: 23453, enName: "", jpName: "", rightAscension: 5.22868, declination: 41.4332, magnitude: 3.69, details: "" )),
        (Star(hipId: 23685, enName: "", jpName: "", rightAscension: 5.52765, declination: -22.22151, magnitude: 3.19, details: "" )),
        (Star(hipId: 23875, enName: "", jpName: "", rightAscension: 5.75103, declination: -5.5105, magnitude: 2.78, details: "" )),
        (Star(hipId: 23972, enName: "", jpName: "", rightAscension: 5.9878, declination: -8.45147, magnitude: 4.25, details: "" )),
        (Star(hipId: 24244, enName: "", jpName: "", rightAscension: 5.121789, declination: -11.5289, magnitude: 4.45, details: "" )),
        (Star(hipId: 24305, enName: "", jpName: "", rightAscension: 5.125587, declination: -16.12195, magnitude: 3.29, details: "" )),
        (Star(hipId: 24327, enName: "", jpName: "", rightAscension: 5.131389, declination: -12.56286, magnitude: 4.36, details: "" )),
        (Star(hipId: 24436, enName: "Rigel", jpName: "リゲル", rightAscension: 5.143227, declination: -8.1259, magnitude: 0.18, details: "" )),
        (Star(hipId: 24608, enName: "Capella A", jpName: "カペラ", rightAscension: 5.16413, declination: 45.59565, magnitude: 0.08, details: "" )),
        (Star(hipId: 24845, enName: "", jpName: "", rightAscension: 5.193453, declination: -13.10364, magnitude: 4.29, details: "" )),
        (Star(hipId: 24873, enName: "", jpName: "", rightAscension: 5.195903, declination: -12.18562, magnitude: 5.29, details: "" )),
        (Star(hipId: 25110, enName: "", jpName: "", rightAscension: 5.223378, declination: 79.13507, magnitude: 5.08, details: "" )),
        (Star(hipId: 25336, enName: "Bellatrix", jpName: "ベラトリックス", rightAscension: 5.25787, declination: 6.2059, magnitude: 1.64, details: "" )),
        (Star(hipId: 25428, enName: "El Nath", jpName: "エルナト", rightAscension: 5.26175, declination: 28.36283, magnitude: 1.65, details: "" )),
        (Star(hipId: 25606, enName: "", jpName: "", rightAscension: 5.281473, declination: -20.45332, magnitude: 2.81, details: "" )),
        (Star(hipId: 25859, enName: "", jpName: "", rightAscension: 5.311274, declination: -35.28136, magnitude: 3.86, details: "" )),
        (Star(hipId: 25918, enName: "", jpName: "", rightAscension: 5.315266, declination: -76.2030, magnitude: 5.18, details: "" )),
        (Star(hipId: 25930, enName: "", jpName: "", rightAscension: 5.324, declination: 0.17567, magnitude: 2.25, details: "" )),
        (Star(hipId: 25985, enName: "Arneb", jpName: "アルネブ", rightAscension: 5.324381, declination: -17.49203, magnitude: 2.58, details: "" )),
        (Star(hipId: 26069, enName: "", jpName: "", rightAscension: 5.333752, declination: -62.29235, magnitude: 3.76, details: "" )),
        (Star(hipId: 26207, enName: "", jpName: "", rightAscension: 5.35828, declination: 9.563, magnitude: 3.39, details: "" )),
        (Star(hipId: 26311, enName: "Alnilam", jpName: "アルニラム", rightAscension: 5.361281, declination: -1.1269, magnitude: 1.69, details: "" )),
        (Star(hipId: 26451, enName: "", jpName: "", rightAscension: 5.373868, declination: 21.8333, magnitude: 2.97, details: "" )),
        (Star(hipId: 26634, enName: "Phact", jpName: "ファクト", rightAscension: 5.393894, declination: -34.4266, magnitude: 2.65, details: "" )),
        (Star(hipId: 26727, enName: "Alnitak A", jpName: "アルニタク", rightAscension: 5.404552, declination: -1.56333, magnitude: 1.74, details: "" )),
        (Star(hipId: 27072, enName: "", jpName: "", rightAscension: 5.442797, declination: -22.2651, magnitude: 3.59, details: "" )),
        (Star(hipId: 27100, enName: "", jpName: "", rightAscension: 5.444642, declination: -65.4479, magnitude: 4.34, details: "" )),
        (Star(hipId: 27288, enName: "", jpName: "", rightAscension: 5.465735, declination: -14.4919, magnitude: 3.55, details: "" )),
        (Star(hipId: 27321, enName: "", jpName: "", rightAscension: 5.471708, declination: -51.42, magnitude: 3.85, details: "" )),
        (Star(hipId: 27366, enName: "Saiph", jpName: "サイフ", rightAscension: 5.474539, declination: -9.40106, magnitude: 2.07, details: "" )),
        (Star(hipId: 27530, enName: "", jpName: "", rightAscension: 5.494958, declination: -56.9594, magnitude: 4.5, details: "" )),
        (Star(hipId: 27628, enName: "", jpName: "", rightAscension: 5.505755, declination: -35.4695, magnitude: 3.12, details: "" )),
        (Star(hipId: 27654, enName: "", jpName: "", rightAscension: 5.511915, declination: -20.5239, magnitude: 3.76, details: "" )),
        (Star(hipId: 27890, enName: "", jpName: "", rightAscension: 5.5459, declination: -63.5277, magnitude: 4.65, details: "" )),
        (Star(hipId: 27913, enName: "", jpName: "", rightAscension: 5.542308, declination: 20.16351, magnitude: 4.39, details: "" )),
        (Star(hipId: 27989, enName: "Betelgeuse", jpName: "ベテルギウス", rightAscension: 5.551029, declination: 7.24253, magnitude: 0.45, details: "" )),
        (Star(hipId: 28103, enName: "", jpName: "", rightAscension: 5.562432, declination: -14.1049, magnitude: 3.71, details: "" )),
        (Star(hipId: 28199, enName: "", jpName: "", rightAscension: 5.573221, declination: -35.16599, magnitude: 4.36, details: "" )),
        (Star(hipId: 28328, enName: "", jpName: "", rightAscension: 5.59879, declination: -42.48544, magnitude: 3.96, details: "" )),
        (Star(hipId: 28360, enName: "", jpName: "", rightAscension: 5.593177, declination: 44.56508, magnitude: 1.9, details: "" )),
        (Star(hipId: 28380, enName: "Bogardus", jpName: "ボガルダス", rightAscension: 5.594324, declination: 37.1246, magnitude: 2.65, details: "" )),
        (Star(hipId: 28614, enName: "", jpName: "", rightAscension: 6.22299, declination: 9.38505, magnitude: 4.12, details: "" )),
        (Star(hipId: 28691, enName: "", jpName: "", rightAscension: 6.32736, declination: 19.41262, magnitude: 5.14, details: "" )),
        (Star(hipId: 28734, enName: "", jpName: "", rightAscension: 6.4722, declination: 23.15491, magnitude: 4.16, details: "" )),
        (Star(hipId: 28910, enName: "", jpName: "", rightAscension: 6.6933, declination: -14.567, magnitude: 4.67, details: "" )),
        (Star(hipId: 29038, enName: "", jpName: "", rightAscension: 6.73432, declination: 14.4667, magnitude: 4.42, details: "" )),
        (Star(hipId: 29151, enName: "", jpName: "", rightAscension: 6.8579, declination: 2.2959, magnitude: 5.7, details: "" )),
        (Star(hipId: 29426, enName: "", jpName: "", rightAscension: 6.11564, declination: 14.12317, magnitude: 4.45, details: "" )),
        (Star(hipId: 29651, enName: "", jpName: "", rightAscension: 6.145134, declination: -6.1629, magnitude: 3.99, details: "" )),
        (Star(hipId: 29655, enName: "", jpName: "", rightAscension: 6.14527, declination: 22.30246, magnitude: 3.31, details: "" )),
        (Star(hipId: 29807, enName: "", jpName: "", rightAscension: 6.163314, declination: -35.8266, magnitude: 4.37, details: "" )),
        (Star(hipId: 30060, enName: "", jpName: "", rightAscension: 6.193739, declination: 59.0393, magnitude: 4.44, details: "" )),
        (Star(hipId: 30122, enName: "", jpName: "", rightAscension: 6.201879, declination: -30.3482, magnitude: 3.02, details: "" )),
        (Star(hipId: 30277, enName: "", jpName: "", rightAscension: 6.22685, declination: -33.26106, magnitude: 3.85, details: "" )),
        (Star(hipId: 30324, enName: "Mirzam", jpName: "ムルジム", rightAscension: 6.224199, declination: -17.57213, magnitude: 1.98, details: "" )),
        (Star(hipId: 30343, enName: "", jpName: "", rightAscension: 6.225759, declination: 22.30499, magnitude: 2.87, details: "" )),
        (Star(hipId: 30419, enName: "", jpName: "", rightAscension: 6.23461, declination: 4.35342, magnitude: 4.39, details: "" )),
        (Star(hipId: 30438, enName: "Canopus", jpName: "カノープス", rightAscension: 6.235709, declination: -52.41446, magnitude: -0.62, details: "" )),
        (Star(hipId: 30867, enName: "", jpName: "", rightAscension: 6.284907, declination: -7.159, magnitude: 3.76, details: "" )),
        (Star(hipId: 30883, enName: "", jpName: "", rightAscension: 6.285779, declination: 20.12438, magnitude: 4.13, details: "" )),
        (Star(hipId: 31416, enName: "", jpName: "", rightAscension: 6.35338, declination: -22.57534, magnitude: 4.54, details: "" )),
        (Star(hipId: 31592, enName: "", jpName: "", rightAscension: 6.3641, declination: -19.15206, magnitude: 3.95, details: "" )),
        (Star(hipId: 31681, enName: "Alhena", jpName: "アルヘナ", rightAscension: 6.37427, declination: 16.23579, magnitude: 1.93, details: "" )),
        (Star(hipId: 31685, enName: "", jpName: "", rightAscension: 6.374567, declination: -43.11453, magnitude: 3.17, details: "" )),
        (Star(hipId: 32246, enName: "", jpName: "", rightAscension: 6.435593, declination: 25.7522, magnitude: 3.06, details: "" )),
        (Star(hipId: 32349, enName: "Sirius A", jpName: "シリウス", rightAscension: 6.45925, declination: -16.42473, magnitude: -1.44, details: "" )),
        (Star(hipId: 32362, enName: "", jpName: "", rightAscension: 6.451743, declination: 12.53458, magnitude: 3.35, details: "" )),
        (Star(hipId: 32607, enName: "", jpName: "", rightAscension: 6.481154, declination: -61.56311, magnitude: 3.24, details: "" )),
        (Star(hipId: 32759, enName: "", jpName: "", rightAscension: 6.495047, declination: -32.30306, magnitude: 3.5, details: "" )),
        (Star(hipId: 32768, enName: "", jpName: "", rightAscension: 6.495614, declination: -50.36518, magnitude: 2.94, details: "" )),
        (Star(hipId: 33018, enName: "", jpName: "", rightAscension: 6.524734, declination: 33.57409, magnitude: 3.6, details: "" )),
        (Star(hipId: 33160, enName: "", jpName: "", rightAscension: 6.541148, declination: -12.2189, magnitude: 4.08, details: "" )),
        (Star(hipId: 33165, enName: "", jpName: "", rightAscension: 6.541305, declination: -23.55421, magnitude: 6.65, details: "" )),
        (Star(hipId: 33347, enName: "", jpName: "", rightAscension: 6.56823, declination: -17.3153, magnitude: 4.36, details: "" )),
        (Star(hipId: 33449, enName: "", jpName: "", rightAscension: 6.57166, declination: 58.2523, magnitude: 4.35, details: "" )),
        (Star(hipId: 33579, enName: "Adara", jpName: "アダーラ", rightAscension: 6.583755, declination: -28.58195, magnitude: 1.5, details: "" )),
        (Star(hipId: 33856, enName: "", jpName: "", rightAscension: 7.14315, declination: -27.5654, magnitude: 3.49, details: "" )),
        (Star(hipId: 33977, enName: "", jpName: "", rightAscension: 7.3147, declination: -23.49599, magnitude: 3.02, details: "" )),
        (Star(hipId: 34045, enName: "", jpName: "", rightAscension: 7.34549, declination: -15.37597, magnitude: 4.11, details: "" )),
        (Star(hipId: 34088, enName: "", jpName: "", rightAscension: 7.4654, declination: 20.34131, magnitude: 4.01, details: "" )),
        (Star(hipId: 34444, enName: "Wezen", jpName: "ウェズン", rightAscension: 7.82349, declination: -26.23355, magnitude: 1.83, details: "" )),
        (Star(hipId: 34481, enName: "", jpName: "", rightAscension: 7.84482, declination: -70.29571, magnitude: 3.78, details: "" )),
        (Star(hipId: 34693, enName: "", jpName: "", rightAscension: 7.11839, declination: 30.1443, magnitude: 4.41, details: "" )),
        (Star(hipId: 34769, enName: "", jpName: "", rightAscension: 7.115186, declination: 0.2934, magnitude: 4.15, details: "" )),
        (Star(hipId: 35037, enName: "", jpName: "", rightAscension: 7.144866, declination: -26.46217, magnitude: 4.01, details: "" )),
        (Star(hipId: 35228, enName: "", jpName: "", rightAscension: 7.164983, declination: -67.57258, magnitude: 3.97, details: "" )),
        (Star(hipId: 35264, enName: "", jpName: "", rightAscension: 7.17856, declination: -37.551, magnitude: 2.71, details: "" )),
        (Star(hipId: 35350, enName: "", jpName: "", rightAscension: 7.18561, declination: 16.32257, magnitude: 3.58, details: "" )),
        (Star(hipId: 35550, enName: "", jpName: "", rightAscension: 7.20739, declination: 21.58564, magnitude: 3.5, details: "" )),
        (Star(hipId: 35904, enName: "Aludra", jpName: "アルドラ", rightAscension: 7.24571, declination: -29.18112, magnitude: 2.45, details: "" )),
        (Star(hipId: 36046, enName: "", jpName: "", rightAscension: 7.254368, declination: 27.47538, magnitude: 3.78, details: "" )),
        (Star(hipId: 36145, enName: "", jpName: "", rightAscension: 7.264286, declination: 49.12419, magnitude: 4.61, details: "" )),
        (Star(hipId: 36188, enName: "", jpName: "", rightAscension: 7.27907, declination: 8.17219, magnitude: 2.89, details: "" )),
        (Star(hipId: 36377, enName: "", jpName: "", rightAscension: 7.291388, declination: -43.1868, magnitude: 3.25, details: "" )),
        (Star(hipId: 36850, enName: "Castor A", jpName: "カストル", rightAscension: 7.3436, declination: 31.53191, magnitude: 1.58, details: "" )),
        (Star(hipId: 36962, enName: "", jpName: "", rightAscension: 7.355537, declination: 26.53456, magnitude: 4.06, details: "" )),
        (Star(hipId: 37279, enName: "Procyon", jpName: "プロキオン", rightAscension: 7.391854, declination: 5.1339, magnitude: 0.4, details: "" )),
        (Star(hipId: 37447, enName: "", jpName: "", rightAscension: 7.411488, declination: -9.3339, magnitude: 3.94, details: "" )),
        (Star(hipId: 37504, enName: "", jpName: "", rightAscension: 7.41492, declination: -72.36221, magnitude: 3.93, details: "" )),
        (Star(hipId: 37740, enName: "", jpName: "", rightAscension: 7.442687, declination: 24.23533, magnitude: 3.57, details: "" )),
        (Star(hipId: 37826, enName: "Pollux", jpName: "ポルックス", rightAscension: 7.451936, declination: 28.1347, magnitude: 1.16, details: "" )),
        (Star(hipId: 38146, enName: "", jpName: "", rightAscension: 7.4917, declination: -24.54441, magnitude: 5.32, details: "" )),
        (Star(hipId: 39429, enName: "Zeta Puppis", jpName: "ナオス", rightAscension: 8.33507, declination: -40.0115, magnitude: 2.21, details: "" )),
        (Star(hipId: 39757, enName: "", jpName: "", rightAscension: 8.7327, declination: -24.1816, magnitude: 2.83, details: "" )),
        (Star(hipId: 39794, enName: "", jpName: "", rightAscension: 8.75584, declination: -68.3717, magnitude: 4.35, details: "" )),
        (Star(hipId: 39863, enName: "", jpName: "", rightAscension: 8.83566, declination: -2.5916, magnitude: 4.36, details: "" )),
        (Star(hipId: 39953, enName: "Regor", jpName: "スハイル・ムーリフ", rightAscension: 8.93196, declination: -47.20118, magnitude: 1.75, details: "" )),
        (Star(hipId: 40526, enName: "", jpName: "", rightAscension: 8.163095, declination: 9.1184, magnitude: 3.53, details: "" )),
        (Star(hipId: 40702, enName: "", jpName: "", rightAscension: 8.183127, declination: -76.55119, magnitude: 4.05, details: "" )),
        (Star(hipId: 40843, enName: "", jpName: "", rightAscension: 8.20387, declination: 27.137, magnitude: 5.13, details: "" )),
        (Star(hipId: 41037, enName: "Avior", jpName: "アヴィオール", rightAscension: 8.223086, declination: -59.30343, magnitude: 1.86, details: "" )),
        (Star(hipId: 41075, enName: "", jpName: "", rightAscension: 8.225013, declination: 43.11181, magnitude: 4.25, details: "" )),
        (Star(hipId: 41312, enName: "", jpName: "", rightAscension: 8.254425, declination: -66.8115, magnitude: 3.77, details: "" )),
        (Star(hipId: 41704, enName: "", jpName: "", rightAscension: 8.301603, declination: 60.4364, magnitude: 3.35, details: "" )),
        (Star(hipId: 42313, enName: "", jpName: "", rightAscension: 8.373941, declination: 5.42137, magnitude: 4.14, details: "" )),
        (Star(hipId: 42402, enName: "", jpName: "", rightAscension: 8.384545, declination: 3.20293, magnitude: 4.45, details: "" )),
        (Star(hipId: 42515, enName: "", jpName: "", rightAscension: 8.40614, declination: -35.18299, magnitude: 3.97, details: "" )),
        (Star(hipId: 42536, enName: "", jpName: "", rightAscension: 8.401761, declination: -52.55191, magnitude: 3.6, details: "" )),
        (Star(hipId: 42568, enName: "", jpName: "", rightAscension: 8.403704, declination: -59.45397, magnitude: 4.31, details: "" )),
        (Star(hipId: 42799, enName: "", jpName: "", rightAscension: 8.431349, declination: 3.23552, magnitude: 4.3, details: "" )),
        (Star(hipId: 42806, enName: "", jpName: "", rightAscension: 8.431721, declination: 21.2869, magnitude: 4.66, details: "" )),
        (Star(hipId: 42828, enName: "", jpName: "", rightAscension: 8.433555, declination: -33.11111, magnitude: 3.68, details: "" )),
        (Star(hipId: 42911, enName: "", jpName: "", rightAscension: 8.444111, declination: 18.9175, magnitude: 3.94, details: "" )),
        (Star(hipId: 42913, enName: "Koo She", jpName: "クー･シー", rightAscension: 8.44422, declination: -54.42308, magnitude: 1.93, details: "" )),
        (Star(hipId: 43103, enName: "", jpName: "", rightAscension: 8.464183, declination: 28.4536, magnitude: 4.03, details: "" )),
        (Star(hipId: 43109, enName: "", jpName: "", rightAscension: 8.464665, declination: 6.2581, magnitude: 3.38, details: "" )),
        (Star(hipId: 43234, enName: "", jpName: "", rightAscension: 8.482598, declination: 5.50164, magnitude: 4.35, details: "" )),
        (Star(hipId: 43409, enName: "", jpName: "", rightAscension: 8.503201, declination: -27.42362, magnitude: 4.02, details: "" )),
        (Star(hipId: 43813, enName: "", jpName: "", rightAscension: 8.552368, declination: 5.56439, magnitude: 3.11, details: "" )),
        (Star(hipId: 44066, enName: "", jpName: "", rightAscension: 8.58292, declination: 11.5128, magnitude: 4.26, details: "" )),
        (Star(hipId: 44127, enName: "", jpName: "", rightAscension: 8.591284, declination: 48.2325, magnitude: 3.12, details: "" )),
        (Star(hipId: 44248, enName: "", jpName: "", rightAscension: 9.03875, declination: 41.474, magnitude: 3.96, details: "" )),
        (Star(hipId: 44382, enName: "", jpName: "", rightAscension: 9.2268, declination: -66.2345, magnitude: 4, details: "" )),
        (Star(hipId: 44471, enName: "", jpName: "", rightAscension: 9.33756, declination: 47.924, magnitude: 3.57, details: "" )),
        (Star(hipId: 44700, enName: "", jpName: "", rightAscension: 9.63179, declination: 38.2781, magnitude: 4.56, details: "" )),
        (Star(hipId: 44816, enName: "Lambda Velorum", jpName: "スハイル・ワズン", rightAscension: 9.75978, declination: -43.25574, magnitude: 2.23, details: "" )),
        (Star(hipId: 45080, enName: "", jpName: "", rightAscension: 9.105811, declination: -58.589, magnitude: 3.43, details: "" )),
        (Star(hipId: 45238, enName: "Miaplacidus", jpName: "ミアプラキドゥス", rightAscension: 9.131224, declination: -69.4329, magnitude: 1.67, details: "" )),
        (Star(hipId: 45336, enName: "", jpName: "", rightAscension: 9.142179, declination: 2.18541, magnitude: 3.89, details: "" )),
        (Star(hipId: 45556, enName: "Aspidiske", jpName: "アスピディスケ", rightAscension: 9.17543, declination: -59.16309, magnitude: 2.21, details: "" )),
        (Star(hipId: 45688, enName: "", jpName: "", rightAscension: 9.185067, declination: 36.48104, magnitude: 3.82, details: "" )),
        (Star(hipId: 45860, enName: "", jpName: "", rightAscension: 9.21346, declination: 34.23331, magnitude: 3.14, details: "" )),
        (Star(hipId: 45941, enName: "Kappa Velorum", jpName: "ほ座カッパ星", rightAscension: 9.22683, declination: -55.0385, magnitude: 2.47, details: "" )),
        (Star(hipId: 46390, enName: "Alphard", jpName: "アルファルド", rightAscension: 9.273525, declination: -8.39313, magnitude: 1.99, details: "" )),
        (Star(hipId: 46509, enName: "", jpName: "", rightAscension: 9.29884, declination: -2.4682, magnitude: 4.59, details: "" )),
        (Star(hipId: 46651, enName: "", jpName: "", rightAscension: 9.304211, declination: -40.288, magnitude: 3.6, details: "" )),
        (Star(hipId: 46733, enName: "", jpName: "", rightAscension: 9.313157, declination: 63.3425, magnitude: 3.65, details: "" )),
        (Star(hipId: 46776, enName: "", jpName: "", rightAscension: 9.315893, declination: -1.1148, magnitude: 4.54, details: "" )),
        (Star(hipId: 46853, enName: "", jpName: "", rightAscension: 9.325233, declination: 51.4043, magnitude: 3.17, details: "" )),
        (Star(hipId: 46952, enName: "", jpName: "", rightAscension: 9.341338, declination: 36.23514, magnitude: 4.54, details: "" )),
        (Star(hipId: 47908, enName: "", jpName: "", rightAscension: 9.45511, declination: 23.46274, magnitude: 2.97, details: "" )),
        (Star(hipId: 48319, enName: "", jpName: "", rightAscension: 9.505969, declination: 59.2208, magnitude: 3.78, details: "" )),
        (Star(hipId: 48356, enName: "", jpName: "", rightAscension: 9.512868, declination: -14.50476, magnitude: 4.11, details: "" )),
        (Star(hipId: 48402, enName: "", jpName: "", rightAscension: 9.52636, declination: 54.3514, magnitude: 4.55, details: "" )),
        (Star(hipId: 48455, enName: "", jpName: "", rightAscension: 9.524596, declination: 26.0255, magnitude: 3.88, details: "" )),
        (Star(hipId: 48774, enName: "", jpName: "", rightAscension: 9.565175, declination: -54.3441, magnitude: 3.52, details: "" )),
        (Star(hipId: 48926, enName: "", jpName: "", rightAscension: 9.585234, declination: -35.53274, magnitude: 5.23, details: "" )),
        (Star(hipId: 49583, enName: "", jpName: "", rightAscension: 10.71995, declination: 16.45456, magnitude: 3.48, details: "" )),
        (Star(hipId: 49593, enName: "", jpName: "", rightAscension: 10.72573, declination: 35.14409, magnitude: 4.49, details: "" )),
        (Star(hipId: 49641, enName: "", jpName: "", rightAscension: 10.7563, declination: 0.22179, magnitude: 4.48, details: "" )),
        (Star(hipId: 49669, enName: "Regulus", jpName: "レグルス", rightAscension: 10.82246, declination: 11.5819, magnitude: 1.36, details: "" )),
        (Star(hipId: 49841, enName: "", jpName: "", rightAscension: 10.10354, declination: -12.21138, magnitude: 3.61, details: "" )),
        (Star(hipId: 50099, enName: "", jpName: "", rightAscension: 10.134428, declination: -70.2165, magnitude: 3.29, details: "" )),
        (Star(hipId: 50191, enName: "", jpName: "", rightAscension: 10.144427, declination: -42.7194, magnitude: 3.85, details: "" )),
        (Star(hipId: 50335, enName: "", jpName: "", rightAscension: 10.16414, declination: 23.2524, magnitude: 3.43, details: "" )),
        (Star(hipId: 50371, enName: "", jpName: "", rightAscension: 10.17501, declination: -61.19564, magnitude: 3.39, details: "" )),
        (Star(hipId: 50372, enName: "", jpName: "", rightAscension: 10.17593, declination: 42.54521, magnitude: 3.45, details: "" )),
        (Star(hipId: 50583, enName: "Algieba", jpName: "アルギエバ", rightAscension: 10.195816, declination: 19.50307, magnitude: 2.01, details: "" )),
        (Star(hipId: 50801, enName: "", jpName: "", rightAscension: 10.22198, declination: 41.2958, magnitude: 3.06, details: "" )),
        (Star(hipId: 51069, enName: "", jpName: "", rightAscension: 10.26551, declination: -16.5099, magnitude: 3.83, details: "" )),
        (Star(hipId: 51172, enName: "", jpName: "", rightAscension: 10.27916, declination: -31.441, magnitude: 4.28, details: "" )),
        (Star(hipId: 51232, enName: "", jpName: "", rightAscension: 10.275275, declination: -58.44219, magnitude: 3.81, details: "" )),
        (Star(hipId: 51233, enName: "", jpName: "", rightAscension: 10.275309, declination: 36.42269, magnitude: 4.2, details: "" )),
        (Star(hipId: 51437, enName: "", jpName: "", rightAscension: 10.30175, declination: 0.38131, magnitude: 5.08, details: "" )),
        (Star(hipId: 51839, enName: "", jpName: "", rightAscension: 10.352822, declination: -78.36281, magnitude: 4.11, details: "" )),
        (Star(hipId: 51986, enName: "", jpName: "", rightAscension: 10.371826, declination: -48.13322, magnitude: 3.84, details: "" )),
        (Star(hipId: 52419, enName: "", jpName: "", rightAscension: 10.425743, declination: -64.23401, magnitude: 2.74, details: "" )),
        (Star(hipId: 52468, enName: "", jpName: "", rightAscension: 10.433231, declination: -60.33599, magnitude: 4.58, details: "" )),
        (Star(hipId: 52727, enName: "", jpName: "", rightAscension: 10.464612, declination: -49.25125, magnitude: 2.69, details: "" )),
        (Star(hipId: 52943, enName: "", jpName: "", rightAscension: 10.493743, declination: -16.11389, magnitude: 3.11, details: "" )),
        (Star(hipId: 53229, enName: "", jpName: "", rightAscension: 10.531864, declination: 34.1256, magnitude: 3.79, details: "" )),
        (Star(hipId: 53253, enName: "", jpName: "", rightAscension: 10.532957, declination: -58.51118, magnitude: 3.78, details: "" )),
        (Star(hipId: 53740, enName: "", jpName: "", rightAscension: 10.594675, declination: -18.17568, magnitude: 4.08, details: "" )),
        (Star(hipId: 53910, enName: "Merak", jpName: "メラク", rightAscension: 11.15039, declination: 56.22564, magnitude: 2.34, details: "" )),
        (Star(hipId: 54061, enName: "Dubhe", jpName: "ドゥーベ", rightAscension: 11.34384, declination: 61.454, magnitude: 1.81, details: "" )),
        (Star(hipId: 54463, enName: "", jpName: "", rightAscension: 11.8354, declination: -58.58302, magnitude: 3.93, details: "" )),
        (Star(hipId: 54539, enName: "", jpName: "", rightAscension: 11.93986, declination: 44.29548, magnitude: 3, details: "" )),
        (Star(hipId: 54682, enName: "", jpName: "", rightAscension: 11.113949, declination: -22.49322, magnitude: 4.46, details: "" )),
        (Star(hipId: 54872, enName: "Zosma", jpName: "ゾスマ", rightAscension: 11.14641, declination: 20.31265, magnitude: 2.56, details: "" )),
        (Star(hipId: 54879, enName: "", jpName: "", rightAscension: 11.141444, declination: 15.25471, magnitude: 3.33, details: "" )),
        (Star(hipId: 55282, enName: "", jpName: "", rightAscension: 11.192052, declination: -14.46446, magnitude: 3.56, details: "" )),
        (Star(hipId: 55687, enName: "", jpName: "", rightAscension: 11.243661, declination: -10.51338, magnitude: 4.81, details: "" )),
        (Star(hipId: 55705, enName: "", jpName: "", rightAscension: 11.245298, declination: -17.4125, magnitude: 4.06, details: "" )),
        (Star(hipId: 56211, enName: "", jpName: "", rightAscension: 11.312429, declination: 69.1952, magnitude: 3.82, details: "" )),
        (Star(hipId: 56343, enName: "", jpName: "", rightAscension: 11.3326, declination: -31.51271, magnitude: 3.54, details: "" )),
        (Star(hipId: 56480, enName: "", jpName: "", rightAscension: 11.344571, declination: -54.15509, magnitude: 4.62, details: "" )),
        (Star(hipId: 56561, enName: "", jpName: "", rightAscension: 11.354693, declination: -63.1114, magnitude: 3.11, details: "" )),
        (Star(hipId: 56633, enName: "", jpName: "", rightAscension: 11.364095, declination: -9.4881, magnitude: 4.7, details: "" )),
        (Star(hipId: 57283, enName: "", jpName: "", rightAscension: 11.444576, declination: -18.2122, magnitude: 4.71, details: "" )),
        (Star(hipId: 57363, enName: "", jpName: "", rightAscension: 11.453657, declination: -66.43438, magnitude: 3.63, details: "" )),
        (Star(hipId: 57380, enName: "", jpName: "", rightAscension: 11.455157, declination: 6.31473, magnitude: 4.04, details: "" )),
        (Star(hipId: 57399, enName: "", jpName: "", rightAscension: 11.46313, declination: 47.46456, magnitude: 3.69, details: "" )),
        (Star(hipId: 57632, enName: "Denebola", jpName: "デネボラ", rightAscension: 11.49388, declination: 14.34204, magnitude: 2.14, details: "" )),
        (Star(hipId: 57936, enName: "", jpName: "", rightAscension: 11.525456, declination: -33.54293, magnitude: 4.29, details: "" )),
        (Star(hipId: 58001, enName: "Phecda", jpName: "フェクダ", rightAscension: 11.534974, declination: 53.4141, magnitude: 2.41, details: "" )),
        (Star(hipId: 58188, enName: "", jpName: "", rightAscension: 11.5698, declination: -17.929, magnitude: 5.17, details: "" )),
        (Star(hipId: 59196, enName: "", jpName: "", rightAscension: 12.82154, declination: -50.43207, magnitude: 2.58, details: "" )),
        (Star(hipId: 59199, enName: "", jpName: "", rightAscension: 12.82475, declination: -24.43436, magnitude: 4.02, details: "" )),
        (Star(hipId: 59316, enName: "", jpName: "", rightAscension: 12.10753, declination: -22.37113, magnitude: 3.02, details: "" )),
        (Star(hipId: 59747, enName: "", jpName: "", rightAscension: 12.15876, declination: -58.4456, magnitude: 2.79, details: "" )),
        (Star(hipId: 59774, enName: "", jpName: "", rightAscension: 12.152545, declination: 57.1574, magnitude: 3.32, details: "" )),
        (Star(hipId: 59803, enName: "Gienah", jpName: "からす座ガンマ星", rightAscension: 12.154847, declination: -17.32311, magnitude: 2.58, details: "" )),
        (Star(hipId: 60000, enName: "", jpName: "", rightAscension: 12.182094, declination: -79.18442, magnitude: 4.24, details: "" )),
        (Star(hipId: 60030, enName: "", jpName: "", rightAscension: 12.18403, declination: 0.47137, magnitude: 5.9, details: "" )),
        (Star(hipId: 60718, enName: "Acrux", jpName: "アクルックス", rightAscension: 12.263594, declination: -63.5566, magnitude: 0.77, details: "" )),
        (Star(hipId: 60742, enName: "", jpName: "", rightAscension: 12.265633, declination: 28.167, magnitude: 4.35, details: "" )),
        (Star(hipId: 60823, enName: "", jpName: "", rightAscension: 12.28241, declination: -50.13502, magnitude: 3.91, details: "" )),
        (Star(hipId: 60965, enName: "", jpName: "", rightAscension: 12.295198, declination: -16.30543, magnitude: 2.94, details: "" )),
        (Star(hipId: 61084, enName: "Gacrux", jpName: "ガクルックス", rightAscension: 12.31993, declination: -57.6452, magnitude: 1.59, details: "" )),
        (Star(hipId: 61174, enName: "", jpName: "", rightAscension: 12.32448, declination: -16.11451, magnitude: 4.3, details: "" )),
        (Star(hipId: 61199, enName: "", jpName: "", rightAscension: 12.322811, declination: -72.7587, magnitude: 3.84, details: "" )),
        (Star(hipId: 61281, enName: "", jpName: "", rightAscension: 12.332904, declination: 69.47176, magnitude: 3.85, details: "" )),
        (Star(hipId: 61317, enName: "", jpName: "", rightAscension: 12.334509, declination: 41.21244, magnitude: 4.24, details: "" )),
        (Star(hipId: 61359, enName: "Kraz", jpName: "クラズ", rightAscension: 12.342323, declination: -23.23478, magnitude: 2.65, details: "" )),
        (Star(hipId: 61585, enName: "", jpName: "", rightAscension: 12.371108, declination: -69.879, magnitude: 2.69, details: "" )),
        (Star(hipId: 61932, enName: "", jpName: "", rightAscension: 12.41312, declination: -48.57356, magnitude: 2.2, details: "" )),
        (Star(hipId: 61941, enName: "", jpName: "", rightAscension: 12.4140, declination: -1.26583, magnitude: 2.74, details: "" )),
        (Star(hipId: 62322, enName: "", jpName: "", rightAscension: 12.461687, declination: -68.6291, magnitude: 3.04, details: "" )),
        (Star(hipId: 62434, enName: "Mimosa", jpName: "ミモザ", rightAscension: 12.474332, declination: -59.41194, magnitude: 1.25, details: "" )),
        (Star(hipId: 62956, enName: "Alioth", jpName: "アリオト", rightAscension: 12.54163, declination: 55.57354, magnitude: 1.76, details: "" )),
        (Star(hipId: 63090, enName: "", jpName: "", rightAscension: 12.553648, declination: 3.23514, magnitude: 3.39, details: "" )),
        (Star(hipId: 63125, enName: "", jpName: "", rightAscension: 12.56184, declination: 38.1957, magnitude: 2.89, details: "" )),
        (Star(hipId: 63608, enName: "", jpName: "", rightAscension: 13.21076, declination: 10.57328, magnitude: 2.85, details: "" )),
        (Star(hipId: 64166, enName: "", jpName: "", rightAscension: 13.9328, declination: -23.747, magnitude: 4.94, details: "" )),
        (Star(hipId: 64241, enName: "", jpName: "", rightAscension: 13.95955, declination: 17.31448, magnitude: 4.32, details: "" )),
        (Star(hipId: 64394, enName: "", jpName: "", rightAscension: 13.115292, declination: 27.52337, magnitude: 4.23, details: "" )),
        (Star(hipId: 64962, enName: "", jpName: "", rightAscension: 13.185525, declination: -23.10171, magnitude: 2.99, details: "" )),
        (Star(hipId: 65109, enName: "", jpName: "", rightAscension: 13.203607, declination: -36.42435, magnitude: 2.75, details: "" )),
        (Star(hipId: 65378, enName: "Mizar A", jpName: "ミザール", rightAscension: 13.235542, declination: 54.55315, magnitude: 2.23, details: "" )),
        (Star(hipId: 65474, enName: "Spica", jpName: "スピカ", rightAscension: 13.25116, declination: -11.9405, magnitude: 0.98, details: "" )),
        (Star(hipId: 65936, enName: "", jpName: "", rightAscension: 13.31267, declination: -39.24262, magnitude: 3.9, details: "" )),
        (Star(hipId: 66249, enName: "", jpName: "", rightAscension: 13.344175, declination: 0.35454, magnitude: 3.38, details: "" )),
        (Star(hipId: 66657, enName: "Epsilon Centauri", jpName: "バーダン", rightAscension: 13.395327, declination: -53.27589, magnitude: 2.29, details: "" )),
        (Star(hipId: 67301, enName: "Alkaid", jpName: "ベネトナシュ", rightAscension: 13.473255, declination: 49.18479, magnitude: 1.85, details: "" )),
        (Star(hipId: 67459, enName: "", jpName: "", rightAscension: 13.49287, declination: 15.47521, magnitude: 4.05, details: "" )),
        (Star(hipId: 67464, enName: "", jpName: "", rightAscension: 13.49303, declination: -41.41156, magnitude: 3.41, details: "" )),
        (Star(hipId: 67472, enName: "", jpName: "", rightAscension: 13.493701, declination: -42.28253, magnitude: 3.47, details: "" )),
        (Star(hipId: 67927, enName: "", jpName: "", rightAscension: 13.544112, declination: 18.23549, magnitude: 2.68, details: "" )),
        (Star(hipId: 68002, enName: "Zeta Centauri", jpName: "ケンタウルス座ゼータ星", rightAscension: 13.553243, declination: -47.17178, magnitude: 2.55, details: "" )),
        (Star(hipId: 68282, enName: "", jpName: "", rightAscension: 13.584077, declination: -44.48127, magnitude: 3.87, details: "" )),
        (Star(hipId: 68520, enName: "", jpName: "", rightAscension: 14.13878, declination: 1.32405, magnitude: 4.23, details: "" )),
        (Star(hipId: 68702, enName: "Hadar", jpName: "ハダル", rightAscension: 14.34944, declination: -60.22227, magnitude: 0.61, details: "" )),
        (Star(hipId: 68756, enName: "", jpName: "", rightAscension: 14.42343, declination: 64.22329, magnitude: 3.67, details: "" )),
        (Star(hipId: 68933, enName: "Menkent", jpName: "メンケント", rightAscension: 14.64132, declination: -36.2273, magnitude: 2.06, details: "" )),
        (Star(hipId: 69427, enName: "", jpName: "", rightAscension: 14.125374, declination: -10.16266, magnitude: 4.18, details: "" )),
        (Star(hipId: 69673, enName: "Arcturus", jpName: "アルクトゥルス", rightAscension: 14.154035, declination: 19.11142, magnitude: -0.05, details: "" )),
        (Star(hipId: 69701, enName: "", jpName: "", rightAscension: 14.1688, declination: -5.59583, magnitude: 4.07, details: "" )),
        (Star(hipId: 70576, enName: "", jpName: "", rightAscension: 14.26108, declination: -45.22453, magnitude: 4.33, details: "" )),
        (Star(hipId: 70638, enName: "", jpName: "", rightAscension: 14.265574, declination: -83.4043, magnitude: 4.31, details: "" )),
        (Star(hipId: 71053, enName: "", jpName: "", rightAscension: 14.314986, declination: 30.22161, magnitude: 3.57, details: "" )),
        (Star(hipId: 71075, enName: "", jpName: "", rightAscension: 14.32476, declination: 38.18284, magnitude: 3.04, details: "" )),
        (Star(hipId: 71352, enName: "Eta Centauri", jpName: "イータ・ケンタウリ", rightAscension: 14.353045, declination: -42.9279, magnitude: 2.33, details: "" )),
        (Star(hipId: 71536, enName: "", jpName: "", rightAscension: 14.375325, declination: -49.25327, magnitude: 4.05, details: "" )),
        (Star(hipId: 71683, enName: "Alpha Centauri A", jpName: "リジル・ケンタウルス", rightAscension: 14.39409, declination: -60.5065, magnitude: -0.01, details: "" )),
        (Star(hipId: 71795, enName: "", jpName: "", rightAscension: 14.41892, declination: 13.4342, magnitude: 3.78, details: "" )),
        (Star(hipId: 71860, enName: "Alpha Lupi", jpName: "カッカブ", rightAscension: 14.415577, declination: -47.23173, magnitude: 2.3, details: "" )),
        (Star(hipId: 71908, enName: "", jpName: "", rightAscension: 14.423069, declination: -64.58285, magnitude: 3.18, details: "" )),
        (Star(hipId: 71957, enName: "", jpName: "", rightAscension: 14.43356, declination: -5.39267, magnitude: 3.87, details: "" )),
        (Star(hipId: 72105, enName: "", jpName: "", rightAscension: 14.445925, declination: 27.427, magnitude: 2.35, details: "" )),
        (Star(hipId: 72220, enName: "", jpName: "", rightAscension: 14.461499, declination: 1.53346, magnitude: 3.73, details: "" )),
        (Star(hipId: 72370, enName: "", jpName: "", rightAscension: 14.475173, declination: -79.241, magnitude: 3.83, details: "" )),
        (Star(hipId: 72607, enName: "Kochab", jpName: "コカブ", rightAscension: 14.50424, declination: 74.9197, magnitude: 2.07, details: "" )),
        (Star(hipId: 72622, enName: "", jpName: "", rightAscension: 14.505278, declination: -16.2298, magnitude: 2.75, details: "" )),
        (Star(hipId: 73273, enName: "", jpName: "", rightAscension: 14.583195, declination: -43.819, magnitude: 2.68, details: "" )),
        (Star(hipId: 73334, enName: "", jpName: "", rightAscension: 14.5997, declination: -42.6149, magnitude: 3.13, details: "" )),
        (Star(hipId: 73555, enName: "", jpName: "", rightAscension: 15.15679, declination: 40.23263, magnitude: 3.49, details: "" )),
        (Star(hipId: 73714, enName: "", jpName: "", rightAscension: 15.4426, declination: -25.16547, magnitude: 3.25, details: "" )),
        (Star(hipId: 74395, enName: "", jpName: "", rightAscension: 15.12172, declination: -52.5567, magnitude: 3.41, details: "" )),
        (Star(hipId: 74666, enName: "", jpName: "", rightAscension: 15.15301, declination: 33.18544, magnitude: 3.46, details: "" )),
        (Star(hipId: 74785, enName: "Zubeneschamali", jpName: "ズベン・エス・カマリ", rightAscension: 15.1747, declination: -9.22583, magnitude: 2.61, details: "" )),
        (Star(hipId: 74824, enName: "", jpName: "", rightAscension: 15.173096, declination: -58.4832, magnitude: 4.07, details: "" )),
        (Star(hipId: 74946, enName: "", jpName: "", rightAscension: 15.185469, declination: -68.40461, magnitude: 2.87, details: "" )),
        (Star(hipId: 75097, enName: "", jpName: "", rightAscension: 15.204375, declination: 71.5023, magnitude: 3, details: "" )),
        (Star(hipId: 75141, enName: "", jpName: "", rightAscension: 15.212234, declination: -40.38509, magnitude: 3.22, details: "" )),
        (Star(hipId: 75177, enName: "", jpName: "", rightAscension: 15.214844, declination: -36.15402, magnitude: 3.57, details: "" )),
        (Star(hipId: 75323, enName: "", jpName: "", rightAscension: 15.232266, declination: -59.19145, magnitude: 4.48, details: "" )),
        (Star(hipId: 75458, enName: "", jpName: "", rightAscension: 15.245578, declination: 58.57577, magnitude: 3.29, details: "" )),
        (Star(hipId: 75695, enName: "", jpName: "", rightAscension: 15.274985, declination: 29.6198, magnitude: 3.66, details: "" )),
        (Star(hipId: 76127, enName: "", jpName: "", rightAscension: 15.32558, declination: 31.2133, magnitude: 4.14, details: "" )),
        (Star(hipId: 76267, enName: "Alphecca", jpName: "ゲンマ", rightAscension: 15.344119, declination: 26.42537, magnitude: 2.22, details: "" )),
        (Star(hipId: 76276, enName: "", jpName: "", rightAscension: 15.344819, declination: 10.32199, magnitude: 3.8, details: "" )),
        (Star(hipId: 76297, enName: "", jpName: "", rightAscension: 15.35846, declination: -41.101, magnitude: 2.8, details: "" )),
        (Star(hipId: 76333, enName: "", jpName: "", rightAscension: 15.353154, declination: -14.47224, magnitude: 3.91, details: "" )),
        (Star(hipId: 76552, enName: "", jpName: "", rightAscension: 15.38332, declination: -42.3429, magnitude: 4.34, details: "" )),
        (Star(hipId: 76952, enName: "", jpName: "", rightAscension: 15.424464, declination: 26.17439, magnitude: 3.81, details: "" )),
        (Star(hipId: 77055, enName: "", jpName: "", rightAscension: 15.44346, declination: 77.47402, magnitude: 4.29, details: "" )),
        (Star(hipId: 77070, enName: "Unukalhai", jpName: "ウヌクアルハイ", rightAscension: 15.4416, declination: 6.25319, magnitude: 2.63, details: "" )),
        (Star(hipId: 77233, enName: "", jpName: "", rightAscension: 15.461121, declination: 15.25189, magnitude: 3.65, details: "" )),
        (Star(hipId: 77450, enName: "", jpName: "", rightAscension: 15.484441, declination: 18.8304, magnitude: 4.09, details: "" )),
        (Star(hipId: 77512, enName: "", jpName: "", rightAscension: 15.49357, declination: 26.468, magnitude: 4.59, details: "" )),
        (Star(hipId: 77516, enName: "", jpName: "", rightAscension: 15.493727, declination: -3.25485, magnitude: 3.54, details: "" )),
        (Star(hipId: 77622, enName: "", jpName: "", rightAscension: 15.504889, declination: 4.28393, magnitude: 3.71, details: "" )),
        (Star(hipId: 77634, enName: "", jpName: "", rightAscension: 15.505754, declination: -33.37376, magnitude: 3.97, details: "" )),
        (Star(hipId: 77760, enName: "", jpName: "", rightAscension: 15.524019, declination: 42.270, magnitude: 4.6, details: "" )),
        (Star(hipId: 77853, enName: "", jpName: "", rightAscension: 15.534948, declination: -16.43466, magnitude: 4.13, details: "" )),
        (Star(hipId: 77952, enName: "", jpName: "", rightAscension: 15.55881, declination: -63.25471, magnitude: 2.83, details: "" )),
        (Star(hipId: 78072, enName: "", jpName: "", rightAscension: 15.562699, declination: 15.3953, magnitude: 3.85, details: "" )),
        (Star(hipId: 78159, enName: "", jpName: "", rightAscension: 15.57353, declination: 26.52409, magnitude: 4.14, details: "" )),
        (Star(hipId: 78265, enName: "", jpName: "", rightAscension: 15.585112, declination: -26.6506, magnitude: 2.89, details: "" )),
        (Star(hipId: 78384, enName: "", jpName: "", rightAscension: 16.0734, declination: -38.23479, magnitude: 3.42, details: "" )),
        (Star(hipId: 78401, enName: "Dschubba", jpName: "ジュバ", rightAscension: 16.02001, declination: -22.37178, magnitude: 2.29, details: "" )),
        (Star(hipId: 78493, enName: "", jpName: "", rightAscension: 16.12659, declination: 29.5139, magnitude: 4.98, details: "" )),
        (Star(hipId: 78527, enName: "", jpName: "", rightAscension: 16.1537, declination: 58.3352, magnitude: 4.01, details: "" )),
        (Star(hipId: 78639, enName: "", jpName: "", rightAscension: 16.31286, declination: -49.1347, magnitude: 4.65, details: "" )),
        (Star(hipId: 78820, enName: "Acrab", jpName: "アクラブ", rightAscension: 16.52623, declination: -19.48194, magnitude: 2.56, details: "" )),
        (Star(hipId: 78970, enName: "", jpName: "", rightAscension: 16.71617, declination: -36.45199, magnitude: 5.72, details: "" )),
        (Star(hipId: 79509, enName: "", jpName: "", rightAscension: 16.132873, declination: -54.37495, magnitude: 4.95, details: "" )),
        (Star(hipId: 79822, enName: "", jpName: "", rightAscension: 16.17305, declination: 75.45169, magnitude: 4.95, details: "" )),
        (Star(hipId: 79882, enName: "", jpName: "", rightAscension: 16.181924, declination: -4.41334, magnitude: 3.23, details: "" )),
        (Star(hipId: 79992, enName: "", jpName: "", rightAscension: 16.194445, declination: 46.18478, magnitude: 3.91, details: "" )),
        (Star(hipId: 80000, enName: "", jpName: "", rightAscension: 16.195057, declination: -50.9194, magnitude: 4.01, details: "" )),
        (Star(hipId: 80170, enName: "", jpName: "", rightAscension: 16.215524, declination: 19.9109, magnitude: 3.74, details: "" )),
        (Star(hipId: 80331, enName: "", jpName: "", rightAscension: 16.235951, declination: 61.30507, magnitude: 2.73, details: "" )),
        (Star(hipId: 80582, enName: "", jpName: "", rightAscension: 16.271105, declination: -47.3317, magnitude: 4.46, details: "" )),
        (Star(hipId: 80763, enName: "Antares", jpName: "アンタレス", rightAscension: 16.292447, declination: -26.2555, magnitude: 1.06, details: "" )),
        (Star(hipId: 80816, enName: "", jpName: "", rightAscension: 16.301326, declination: 21.29227, magnitude: 2.78, details: "" )),
        (Star(hipId: 81065, enName: "", jpName: "", rightAscension: 16.332746, declination: -78.53491, magnitude: 3.86, details: "" )),
        (Star(hipId: 81126, enName: "", jpName: "", rightAscension: 16.34619, declination: 42.26128, magnitude: 4.2, details: "" )),
        (Star(hipId: 81266, enName: "", jpName: "", rightAscension: 16.355296, declination: -28.12575, magnitude: 2.82, details: "" )),
        (Star(hipId: 81377, enName: "Zeta Ophiuchi", jpName: "へびつかい座ゼータ星", rightAscension: 16.37953, declination: -10.3417, magnitude: 2.54, details: "" )),
        (Star(hipId: 81693, enName: "", jpName: "", rightAscension: 16.411748, declination: 31.3668, magnitude: 2.81, details: "" )),
        (Star(hipId: 81833, enName: "", jpName: "", rightAscension: 16.425374, declination: 38.55209, magnitude: 3.48, details: "" )),
        (Star(hipId: 81852, enName: "", jpName: "", rightAscension: 16.43542, declination: -77.30597, magnitude: 4.23, details: "" )),
        (Star(hipId: 82080, enName: "", jpName: "", rightAscension: 16.455816, declination: 82.2141, magnitude: 4.21, details: "" )),
        (Star(hipId: 82273, enName: "Atria", jpName: "アトリア", rightAscension: 16.483987, declination: -69.1395, magnitude: 1.91, details: "" )),
        (Star(hipId: 82363, enName: "", jpName: "", rightAscension: 16.494711, declination: -59.2287, magnitude: 3.77, details: "" )),
        (Star(hipId: 82396, enName: "Wei", jpName: "ウェイ", rightAscension: 16.501024, declination: -34.17334, magnitude: 2.29, details: "" )),
        (Star(hipId: 82514, enName: "", jpName: "", rightAscension: 16.515224, declination: -38.2504, magnitude: 3, details: "" )),
        (Star(hipId: 82671, enName: "", jpName: "", rightAscension: 16.535973, declination: -42.21433, magnitude: 4.7, details: "" )),
        (Star(hipId: 83000, enName: "", jpName: "", rightAscension: 16.574027, declination: 9.22302, magnitude: 3.19, details: "" )),
        (Star(hipId: 83081, enName: "", jpName: "", rightAscension: 16.583723, declination: -55.59242, magnitude: 3.12, details: "" )),
        (Star(hipId: 83207, enName: "", jpName: "", rightAscension: 17.01741, declination: 30.55348, magnitude: 3.92, details: "" )),
        (Star(hipId: 83895, enName: "", jpName: "", rightAscension: 17.84723, declination: 65.42527, magnitude: 3.17, details: "" )),
        (Star(hipId: 84012, enName: "", jpName: "", rightAscension: 17.102266, declination: -15.43305, magnitude: 2.43, details: "" )),
        (Star(hipId: 84143, enName: "", jpName: "", rightAscension: 17.12918, declination: -43.14186, magnitude: 3.32, details: "" )),
        (Star(hipId: 84379, enName: "", jpName: "", rightAscension: 17.15192, declination: 24.50225, magnitude: 3.12, details: "" )),
        (Star(hipId: 84380, enName: "", jpName: "", rightAscension: 17.15285, declination: 36.4833, magnitude: 3.16, details: "" )),
        (Star(hipId: 84606, enName: "", jpName: "", rightAscension: 17.174029, declination: 37.17288, magnitude: 4.64, details: "" )),
        (Star(hipId: 84880, enName: "", jpName: "", rightAscension: 17.204964, declination: -12.50488, magnitude: 4.32, details: "" )),
        (Star(hipId: 85112, enName: "", jpName: "", rightAscension: 17.234097, declination: 37.8453, magnitude: 4.15, details: "" )),
        (Star(hipId: 85258, enName: "", jpName: "", rightAscension: 17.2518, declination: -55.31474, magnitude: 2.84, details: "" )),
        (Star(hipId: 85267, enName: "", jpName: "", rightAscension: 17.252366, declination: -56.22397, magnitude: 3.31, details: "" )),
        (Star(hipId: 85670, enName: "", jpName: "", rightAscension: 17.302598, declination: 52.1849, magnitude: 2.79, details: "" )),
        (Star(hipId: 85693, enName: "", jpName: "", rightAscension: 17.30443, declination: 26.6382, magnitude: 4.41, details: "" )),
        (Star(hipId: 85727, enName: "", jpName: "", rightAscension: 17.31598, declination: -60.411, magnitude: 3.6, details: "" )),
        (Star(hipId: 85755, enName: "", jpName: "", rightAscension: 17.312495, declination: -23.57453, magnitude: 4.78, details: "" )),
        (Star(hipId: 85792, enName: "", jpName: "", rightAscension: 17.315052, declination: -49.52335, magnitude: 2.84, details: "" )),
        (Star(hipId: 85822, enName: "", jpName: "", rightAscension: 17.32129, declination: 86.35108, magnitude: 4.35, details: "" )),
        (Star(hipId: 85829, enName: "", jpName: "", rightAscension: 17.321588, declination: 55.10221, magnitude: 4.86, details: "" )),
        (Star(hipId: 85927, enName: "Shaula", jpName: "シャウラ", rightAscension: 17.333653, declination: -37.6135, magnitude: 1.62, details: "" )),
        (Star(hipId: 86032, enName: "Ras Alhague", jpName: "ラス・アルハゲ", rightAscension: 17.3456, declination: 12.33381, magnitude: 2.08, details: "" )),
        (Star(hipId: 86228, enName: "Girtab", jpName: "サルガス", rightAscension: 17.371913, declination: -42.59522, magnitude: 1.86, details: "" )),
        (Star(hipId: 86263, enName: "", jpName: "", rightAscension: 17.373523, declination: -15.23543, magnitude: 3.54, details: "" )),
        (Star(hipId: 86414, enName: "", jpName: "", rightAscension: 17.392789, declination: 46.0228, magnitude: 3.82, details: "" )),
        (Star(hipId: 86565, enName: "", jpName: "", rightAscension: 17.412492, declination: -12.52306, magnitude: 4.24, details: "" )),
        (Star(hipId: 86670, enName: "Girtab", jpName: "ギルタブ", rightAscension: 17.422928, declination: -39.1477, magnitude: 2.39, details: "" )),
        (Star(hipId: 86742, enName: "", jpName: "", rightAscension: 17.432838, declination: 4.349, magnitude: 2.76, details: "" )),
        (Star(hipId: 86929, enName: "", jpName: "", rightAscension: 17.4544, declination: -64.43254, magnitude: 3.61, details: "" )),
        (Star(hipId: 86974, enName: "", jpName: "", rightAscension: 17.462772, declination: 27.4321, magnitude: 3.42, details: "" )),
        (Star(hipId: 87072, enName: "", jpName: "", rightAscension: 17.473363, declination: -27.49507, magnitude: 4.53, details: "" )),
        (Star(hipId: 87073, enName: "", jpName: "", rightAscension: 17.473508, declination: -40.7371, magnitude: 2.99, details: "" )),
        (Star(hipId: 87585, enName: "", jpName: "", rightAscension: 17.533163, declination: 56.52208, magnitude: 3.73, details: "" )),
        (Star(hipId: 87808, enName: "", jpName: "", rightAscension: 17.561518, declination: 37.1519, magnitude: 3.86, details: "" )),
        (Star(hipId: 87833, enName: "Etamin", jpName: "エルタニン", rightAscension: 17.563638, declination: 51.29202, magnitude: 2.24, details: "" )),
        (Star(hipId: 87933, enName: "", jpName: "", rightAscension: 17.574583, declination: 29.14525, magnitude: 3.7, details: "" )),
        (Star(hipId: 88635, enName: "", jpName: "", rightAscension: 18.54852, declination: -30.25251, magnitude: 2.98, details: "" )),
        (Star(hipId: 88714, enName: "", jpName: "", rightAscension: 18.63788, declination: -50.5292, magnitude: 3.65, details: "" )),
        (Star(hipId: 88794, enName: "", jpName: "", rightAscension: 18.73255, declination: 28.45449, magnitude: 3.84, details: "" )),
        (Star(hipId: 88866, enName: "", jpName: "", rightAscension: 18.83479, declination: -63.405, magnitude: 4.33, details: "" )),
        (Star(hipId: 89341, enName: "", jpName: "", rightAscension: 18.134581, declination: -21.3318, magnitude: 3.84, details: "" )),
        (Star(hipId: 89642, enName: "", jpName: "", rightAscension: 18.173773, declination: -36.45406, magnitude: 3.1, details: "" )),
        (Star(hipId: 89931, enName: "", jpName: "", rightAscension: 18.205962, declination: -29.49409, magnitude: 2.72, details: "" )),
        (Star(hipId: 89937, enName: "", jpName: "", rightAscension: 18.21234, declination: 72.4413, magnitude: 3.55, details: "" )),
        (Star(hipId: 89962, enName: "", jpName: "", rightAscension: 18.211892, declination: -2.53496, magnitude: 3.23, details: "" )),
        (Star(hipId: 90098, enName: "", jpName: "", rightAscension: 18.231362, declination: -61.29381, magnitude: 4.35, details: "" )),
        (Star(hipId: 90185, enName: "Kaus Australis", jpName: "カウス・アウストラリス", rightAscension: 18.241035, declination: -34.2335, magnitude: 1.79, details: "" )),
        (Star(hipId: 90422, enName: "", jpName: "", rightAscension: 18.265843, declination: -45.586, magnitude: 3.49, details: "" )),
        (Star(hipId: 90496, enName: "", jpName: "", rightAscension: 18.275827, declination: -25.25165, magnitude: 2.82, details: "" )),
        (Star(hipId: 90568, enName: "", jpName: "", rightAscension: 18.284974, declination: -49.4121, magnitude: 4.1, details: "" )),
        (Star(hipId: 90595, enName: "", jpName: "", rightAscension: 18.291185, declination: -14.33569, magnitude: 4.67, details: "" )),
        (Star(hipId: 90887, enName: "", jpName: "", rightAscension: 18.322131, declination: -39.42141, magnitude: 5.16, details: "" )),
        (Star(hipId: 91117, enName: "", jpName: "", rightAscension: 18.351244, declination: -8.14359, magnitude: 3.85, details: "" )),
        (Star(hipId: 91262, enName: "Vega", jpName: "ベガ", rightAscension: 18.365619, declination: 38.46588, magnitude: 0.03, details: "" )),
        (Star(hipId: 91792, enName: "", jpName: "", rightAscension: 18.43213, declination: -71.25398, magnitude: 4.01, details: "" )),
        (Star(hipId: 91875, enName: "", jpName: "", rightAscension: 18.434694, declination: -38.19239, magnitude: 5.11, details: "" )),
        (Star(hipId: 91971, enName: "", jpName: "", rightAscension: 18.444634, declination: 37.36182, magnitude: 4.34, details: "" )),
        (Star(hipId: 92041, enName: "", jpName: "", rightAscension: 18.453935, declination: -26.59268, magnitude: 3.17, details: "" )),
        (Star(hipId: 92175, enName: "", jpName: "", rightAscension: 18.471048, declination: -4.44522, magnitude: 4.22, details: "" )),
        (Star(hipId: 92202, enName: "", jpName: "", rightAscension: 18.472898, declination: -5.42183, magnitude: 5.38, details: "" )),
        (Star(hipId: 92420, enName: "", jpName: "", rightAscension: 18.50479, declination: 33.21456, magnitude: 3.52, details: "" )),
        (Star(hipId: 92609, enName: "", jpName: "", rightAscension: 18.521304, declination: -62.11152, magnitude: 4.22, details: "" )),
        (Star(hipId: 92791, enName: "", jpName: "", rightAscension: 18.543029, declination: 36.5355, magnitude: 4.22, details: "" )),
        (Star(hipId: 92814, enName: "", jpName: "", rightAscension: 18.544312, declination: -15.36109, magnitude: 5.08, details: "" )),
        (Star(hipId: 92855, enName: "Nunki", jpName: "ヌンキ", rightAscension: 18.551592, declination: -26.17477, magnitude: 2.05, details: "" )),
        (Star(hipId: 92946, enName: "", jpName: "", rightAscension: 18.561316, declination: 4.12127, magnitude: 4.62, details: "" )),
        (Star(hipId: 92953, enName: "", jpName: "", rightAscension: 18.561697, declination: -42.42382, magnitude: 5.35, details: "" )),
        (Star(hipId: 92989, enName: "", jpName: "", rightAscension: 18.564049, declination: -37.20355, magnitude: 5.36, details: "" )),
        (Star(hipId: 93015, enName: "", jpName: "", rightAscension: 18.565704, declination: -67.147, magnitude: 4.4, details: "" )),
        (Star(hipId: 93085, enName: "", jpName: "", rightAscension: 18.574378, declination: -21.6238, magnitude: 3.52, details: "" )),
        (Star(hipId: 93174, enName: "", jpName: "", rightAscension: 18.584347, declination: -37.6255, magnitude: 4.83, details: "" )),
        (Star(hipId: 93194, enName: "", jpName: "", rightAscension: 18.585662, declination: 32.41224, magnitude: 3.25, details: "" )),
        (Star(hipId: 93244, enName: "", jpName: "", rightAscension: 18.593739, declination: 15.465, magnitude: 4.02, details: "" )),
        (Star(hipId: 93506, enName: "Ascella", jpName: "アスケラ", rightAscension: 19.23672, declination: -29.52484, magnitude: 2.6, details: "" )),
        (Star(hipId: 93542, enName: "", jpName: "", rightAscension: 19.3683, declination: -42.542, magnitude: 4.74, details: "" )),
        (Star(hipId: 93683, enName: "", jpName: "", rightAscension: 19.44093, declination: -21.44289, magnitude: 3.76, details: "" )),
        (Star(hipId: 93747, enName: "", jpName: "", rightAscension: 19.52461, declination: 13.51494, magnitude: 2.99, details: "" )),
        (Star(hipId: 93805, enName: "", jpName: "", rightAscension: 19.61495, declination: -4.52564, magnitude: 3.43, details: "" )),
        (Star(hipId: 93825, enName: "", jpName: "", rightAscension: 19.62504, declination: -37.3459, magnitude: 4.23, details: "" )),
        (Star(hipId: 93864, enName: "", jpName: "", rightAscension: 19.65644, declination: -27.40113, magnitude: 3.32, details: "" )),
        (Star(hipId: 94005, enName: "", jpName: "", rightAscension: 19.82093, declination: -40.29479, magnitude: 4.57, details: "" )),
        (Star(hipId: 94114, enName: "", jpName: "", rightAscension: 19.92828, declination: -37.54153, magnitude: 4.11, details: "" )),
        (Star(hipId: 94160, enName: "", jpName: "", rightAscension: 19.10175, declination: -39.20265, magnitude: 4.1, details: "" )),
        (Star(hipId: 94376, enName: "", jpName: "", rightAscension: 19.123315, declination: 67.39407, magnitude: 3.07, details: "" )),
        (Star(hipId: 94779, enName: "", jpName: "", rightAscension: 19.17611, declination: 53.2254, magnitude: 3.8, details: "" )),
        (Star(hipId: 94820, enName: "", jpName: "", rightAscension: 19.173809, declination: -18.57104, magnitude: 4.88, details: "" )),
        (Star(hipId: 95168, enName: "", jpName: "", rightAscension: 19.214038, declination: -17.50501, magnitude: 3.92, details: "" )),
        (Star(hipId: 95294, enName: "", jpName: "", rightAscension: 19.231306, declination: -44.47587, magnitude: 4.27, details: "" )),
        (Star(hipId: 95347, enName: "", jpName: "", rightAscension: 19.235315, declination: -40.36563, magnitude: 3.96, details: "" )),
        (Star(hipId: 95501, enName: "", jpName: "", rightAscension: 19.252975, declination: 3.6525, magnitude: 3.36, details: "" )),
        (Star(hipId: 95771, enName: "", jpName: "", rightAscension: 19.284241, declination: 24.39546, magnitude: 4.44, details: "" )),
        (Star(hipId: 95853, enName: "", jpName: "", rightAscension: 19.294234, declination: 51.43461, magnitude: 3.76, details: "" )),
        (Star(hipId: 95947, enName: "", jpName: "", rightAscension: 19.304329, declination: 27.57349, magnitude: 3.05, details: "" )),
        (Star(hipId: 96406, enName: "", jpName: "", rightAscension: 19.36165, declination: -24.4385, magnitude: 5.64, details: "" )),
        (Star(hipId: 96757, enName: "", jpName: "", rightAscension: 19.40578, declination: 18.0502, magnitude: 4.39, details: "" )),
        (Star(hipId: 96837, enName: "", jpName: "", rightAscension: 19.41293, declination: 17.2834, magnitude: 4.39, details: "" )),
        (Star(hipId: 97165, enName: "", jpName: "", rightAscension: 19.445844, declination: 45.7505, magnitude: 2.86, details: "" )),
        (Star(hipId: 97278, enName: "", jpName: "", rightAscension: 19.461557, declination: 10.36478, magnitude: 2.72, details: "" )),
        (Star(hipId: 97365, enName: "", jpName: "", rightAscension: 19.472327, declination: 18.3233, magnitude: 3.68, details: "" )),
        (Star(hipId: 97433, enName: "", jpName: "", rightAscension: 19.481021, declination: 70.1642, magnitude: 3.84, details: "" )),
        (Star(hipId: 97649, enName: "Altair", jpName: "アルタイル", rightAscension: 19.504668, declination: 8.5226, magnitude: 0.76, details: "" )),
        (Star(hipId: 97804, enName: "", jpName: "", rightAscension: 19.522836, declination: 1.0204, magnitude: 3.87, details: "" )),
        (Star(hipId: 98032, enName: "", jpName: "", rightAscension: 19.551568, declination: -41.5263, magnitude: 4.12, details: "" )),
        (Star(hipId: 98036, enName: "", jpName: "", rightAscension: 19.551877, declination: 6.24286, magnitude: 3.71, details: "" )),
        (Star(hipId: 98110, enName: "", jpName: "", rightAscension: 19.56184, declination: 35.56, magnitude: 3.89, details: "" )),
        (Star(hipId: 98337, enName: "", jpName: "", rightAscension: 19.584539, declination: 19.29315, magnitude: 3.51, details: "" )),
        (Star(hipId: 98412, enName: "", jpName: "", rightAscension: 19.594417, declination: -35.16345, magnitude: 4.37, details: "" )),
        (Star(hipId: 98495, enName: "", jpName: "", rightAscension: 20.03539, declination: -72.54367, magnitude: 3.97, details: "" )),
        (Star(hipId: 98543, enName: "", jpName: "", rightAscension: 20.1601, declination: 27.45128, magnitude: 4.66, details: "" )),
        (Star(hipId: 98688, enName: "", jpName: "", rightAscension: 20.23946, declination: -27.42356, magnitude: 4.43, details: "" )),
        (Star(hipId: 98920, enName: "", jpName: "", rightAscension: 20.5947, declination: 19.59272, magnitude: 5.09, details: "" )),
        (Star(hipId: 99240, enName: "", jpName: "", rightAscension: 20.84186, declination: -66.10456, magnitude: 3.55, details: "" )),
        (Star(hipId: 99473, enName: "", jpName: "", rightAscension: 20.111826, declination: 0.49173, magnitude: 3.24, details: "" )),
        (Star(hipId: 100064, enName: "", jpName: "", rightAscension: 20.18322, declination: -12.32415, magnitude: 3.58, details: "" )),
        (Star(hipId: 100345, enName: "", jpName: "", rightAscension: 20.2165, declination: -14.4653, magnitude: 3.05, details: "" )),
        (Star(hipId: 100453, enName: "Sadr", jpName: "サドル", rightAscension: 20.22137, declination: 40.15241, magnitude: 2.23, details: "" )),
        (Star(hipId: 100751, enName: "Peacock", jpName: "ピーコック", rightAscension: 20.253885, declination: -56.4456, magnitude: 1.94, details: "" )),
        (Star(hipId: 101421, enName: "", jpName: "", rightAscension: 20.331276, declination: 11.1812, magnitude: 4.03, details: "" )),
        (Star(hipId: 101769, enName: "", jpName: "", rightAscension: 20.373287, declination: 14.35427, magnitude: 3.64, details: "" )),
        (Star(hipId: 101772, enName: "", jpName: "", rightAscension: 20.373399, declination: -47.1730, magnitude: 3.11, details: "" )),
        (Star(hipId: 101958, enName: "", jpName: "", rightAscension: 20.393825, declination: 15.54434, magnitude: 3.77, details: "" )),
        (Star(hipId: 102098, enName: "Deneb", jpName: "デネブ", rightAscension: 20.412591, declination: 45.16492, magnitude: 1.25, details: "" )),
        (Star(hipId: 102281, enName: "", jpName: "", rightAscension: 20.432755, declination: 15.4289, magnitude: 4.43, details: "" )),
        (Star(hipId: 102395, enName: "", jpName: "", rightAscension: 20.445756, declination: -66.12117, magnitude: 3.42, details: "" )),
        (Star(hipId: 102485, enName: "", jpName: "", rightAscension: 20.46577, declination: -25.16139, magnitude: 4.13, details: "" )),
        (Star(hipId: 102488, enName: "Gienah", jpName: "ギェナー", rightAscension: 20.461243, declination: 33.5810, magnitude: 2.48, details: "" )),
        (Star(hipId: 102532, enName: "", jpName: "", rightAscension: 20.463952, declination: 16.7292, magnitude: 4.27, details: "" )),
        (Star(hipId: 102618, enName: "", jpName: "", rightAscension: 20.474053, declination: -9.29445, magnitude: 3.78, details: "" )),
        (Star(hipId: 102831, enName: "", jpName: "", rightAscension: 20.495808, declination: -33.46468, magnitude: 4.89, details: "" )),
        (Star(hipId: 102978, enName: "", jpName: "", rightAscension: 20.51493, declination: -26.5589, magnitude: 4.12, details: "" )),
        (Star(hipId: 103227, enName: "", jpName: "", rightAscension: 20.544858, declination: -58.27147, magnitude: 3.67, details: "" )),
        (Star(hipId: 103738, enName: "", jpName: "", rightAscension: 21.11746, declination: -32.1528, magnitude: 4.67, details: "" )),
        (Star(hipId: 104139, enName: "", jpName: "", rightAscension: 21.55678, declination: -17.13578, magnitude: 4.08, details: "" )),
        (Star(hipId: 104521, enName: "", jpName: "", rightAscension: 21.102047, declination: 10.755, magnitude: 4.7, details: "" )),
        (Star(hipId: 104732, enName: "", jpName: "", rightAscension: 21.125618, declination: 30.13375, magnitude: 3.21, details: "" )),
        (Star(hipId: 104858, enName: "", jpName: "", rightAscension: 21.142879, declination: 10.0278, magnitude: 4.47, details: "" )),
        (Star(hipId: 104987, enName: "", jpName: "", rightAscension: 21.15494, declination: 5.14531, magnitude: 3.92, details: "" )),
        (Star(hipId: 105140, enName: "", jpName: "", rightAscension: 21.175625, declination: -32.10209, magnitude: 4.71, details: "" )),
        (Star(hipId: 105199, enName: "Alderamin", jpName: "アルデラミン", rightAscension: 21.183458, declination: 62.3576, magnitude: 2.45, details: "" )),
        (Star(hipId: 105319, enName: "", jpName: "", rightAscension: 21.195188, declination: -53.26574, magnitude: 4.39, details: "" )),
        (Star(hipId: 105515, enName: "", jpName: "", rightAscension: 21.221478, declination: -16.5044, magnitude: 4.28, details: "" )),
        (Star(hipId: 105570, enName: "", jpName: "", rightAscension: 21.225358, declination: 6.4840, magnitude: 5.16, details: "" )),
        (Star(hipId: 105858, enName: "", jpName: "", rightAscension: 21.262649, declination: -65.2253, magnitude: 4.21, details: "" )),
        (Star(hipId: 105881, enName: "", jpName: "", rightAscension: 21.264003, declination: -22.2441, magnitude: 3.77, details: "" )),
        (Star(hipId: 106032, enName: "", jpName: "", rightAscension: 21.283958, declination: 70.33385, magnitude: 3.23, details: "" )),
        (Star(hipId: 106278, enName: "", jpName: "", rightAscension: 21.313352, declination: -5.34162, magnitude: 2.9, details: "" )),
        (Star(hipId: 106985, enName: "", jpName: "", rightAscension: 21.40534, declination: -16.39441, magnitude: 3.69, details: "" )),
        (Star(hipId: 107089, enName: "", jpName: "", rightAscension: 21.412847, declination: -77.23221, magnitude: 3.73, details: "" )),
        (Star(hipId: 107310, enName: "", jpName: "", rightAscension: 21.4484, declination: 28.44356, magnitude: 4.49, details: "" )),
        (Star(hipId: 107315, enName: "Enif", jpName: "エニフ", rightAscension: 21.441114, declination: 9.5230, magnitude: 2.38, details: "" )),
        (Star(hipId: 107354, enName: "", jpName: "", rightAscension: 21.44387, declination: 25.3842, magnitude: 4.14, details: "" )),
        (Star(hipId: 107556, enName: "", jpName: "", rightAscension: 21.47229, declination: -16.7356, magnitude: 2.85, details: "" )),
        (Star(hipId: 107608, enName: "", jpName: "", rightAscension: 21.474417, declination: -30.53539, magnitude: 5.02, details: "" )),
        (Star(hipId: 108085, enName: "", jpName: "", rightAscension: 21.535565, declination: -37.21534, magnitude: 3, details: "" )),
        (Star(hipId: 108661, enName: "", jpName: "", rightAscension: 22.05022, declination: -28.27135, magnitude: 5.43, details: "" )),
        (Star(hipId: 109074, enName: "", jpName: "", rightAscension: 22.54703, declination: 0.19114, magnitude: 2.95, details: "" )),
        (Star(hipId: 109111, enName: "", jpName: "", rightAscension: 22.669, declination: -39.3235, magnitude: 4.47, details: "" )),
        (Star(hipId: 109139, enName: "", jpName: "", rightAscension: 22.62621, declination: -13.52103, magnitude: 4.29, details: "" )),
        (Star(hipId: 109176, enName: "", jpName: "", rightAscension: 22.747, declination: 25.20422, magnitude: 3.77, details: "" )),
        (Star(hipId: 109268, enName: "Alnair", jpName: "アルナイル", rightAscension: 22.81388, declination: -46.57382, magnitude: 1.73, details: "" )),
        (Star(hipId: 109352, enName: "", jpName: "", rightAscension: 22.91368, declination: 33.1021, magnitude: 5.58, details: "" )),
        (Star(hipId: 109422, enName: "", jpName: "", rightAscension: 22.10848, declination: -32.32544, magnitude: 4.94, details: "" )),
        (Star(hipId: 109427, enName: "", jpName: "", rightAscension: 22.101182, declination: 6.1152, magnitude: 3.52, details: "" )),
        (Star(hipId: 109492, enName: "", jpName: "", rightAscension: 22.105126, declination: 58.1245, magnitude: 3.39, details: "" )),
        (Star(hipId: 109937, enName: "", jpName: "", rightAscension: 22.155817, declination: 37.44554, magnitude: 4.14, details: "" )),
        (Star(hipId: 110003, enName: "", jpName: "", rightAscension: 22.164997, declination: -7.46597, magnitude: 4.17, details: "" )),
        (Star(hipId: 110130, enName: "", jpName: "", rightAscension: 22.183018, declination: -60.15342, magnitude: 2.87, details: "" )),
        (Star(hipId: 110395, enName: "", jpName: "", rightAscension: 22.21393, declination: -1.23145, magnitude: 3.86, details: "" )),
        (Star(hipId: 110538, enName: "", jpName: "", rightAscension: 22.233364, declination: 52.13462, magnitude: 4.42, details: "" )),
        (Star(hipId: 110609, enName: "", jpName: "", rightAscension: 22.2431, declination: 49.2835, magnitude: 4.55, details: "" )),
        (Star(hipId: 110960, enName: "", jpName: "", rightAscension: 22.28498, declination: 0.1122, magnitude: 3.65, details: "" )),
        (Star(hipId: 110997, enName: "", jpName: "", rightAscension: 22.291615, declination: -43.2944, magnitude: 3.97, details: "" )),
        (Star(hipId: 111022, enName: "", jpName: "", rightAscension: 22.293182, declination: 47.42248, magnitude: 4.34, details: "" )),
        (Star(hipId: 111104, enName: "", jpName: "", rightAscension: 22.302926, declination: 43.7242, magnitude: 4.52, details: "" )),
        (Star(hipId: 111123, enName: "", jpName: "", rightAscension: 22.303882, declination: -10.40404, magnitude: 4.82, details: "" )),
        (Star(hipId: 111169, enName: "", jpName: "", rightAscension: 22.311738, declination: 50.16568, magnitude: 3.76, details: "" )),
        (Star(hipId: 111188, enName: "", jpName: "", rightAscension: 22.313029, declination: -32.20457, magnitude: 4.29, details: "" )),
        (Star(hipId: 111497, enName: "", jpName: "", rightAscension: 22.352133, declination: 0.725, magnitude: 4.04, details: "" )),
        (Star(hipId: 111954, enName: "", jpName: "", rightAscension: 22.403933, declination: -27.237, magnitude: 4.18, details: "" )),
        (Star(hipId: 112029, enName: "", jpName: "", rightAscension: 22.412767, declination: 10.4953, magnitude: 3.41, details: "" )),
        (Star(hipId: 112122, enName: "Beta Gruis", jpName: "グライド", rightAscension: 22.423993, declination: -46.5344, magnitude: 2.07, details: "" )),
        (Star(hipId: 112158, enName: "", jpName: "", rightAscension: 22.4313, declination: 30.13167, magnitude: 2.93, details: "" )),
        (Star(hipId: 112405, enName: "", jpName: "", rightAscension: 22.46372, declination: -81.22538, magnitude: 4.13, details: "" )),
        (Star(hipId: 112440, enName: "", jpName: "", rightAscension: 22.463184, declination: 23.33564, magnitude: 3.97, details: "" )),
        (Star(hipId: 112447, enName: "", jpName: "", rightAscension: 22.464144, declination: 12.10267, magnitude: 4.2, details: "" )),
        (Star(hipId: 112623, enName: "", jpName: "", rightAscension: 22.48332, declination: -51.191, magnitude: 3.49, details: "" )),
        (Star(hipId: 112716, enName: "", jpName: "", rightAscension: 22.493551, declination: -13.35331, magnitude: 4.05, details: "" )),
        (Star(hipId: 112724, enName: "", jpName: "", rightAscension: 22.494091, declination: 66.1226, magnitude: 3.5, details: "" )),
        (Star(hipId: 112748, enName: "", jpName: "", rightAscension: 22.501, declination: 24.3661, magnitude: 3.51, details: "" )),
        (Star(hipId: 112961, enName: "", jpName: "", rightAscension: 22.523686, declination: -7.34468, magnitude: 3.73, details: "" )),
        (Star(hipId: 113136, enName: "", jpName: "", rightAscension: 22.543904, declination: -15.49147, magnitude: 3.27, details: "" )),
        (Star(hipId: 113246, enName: "", jpName: "", rightAscension: 22.555689, declination: -32.32229, magnitude: 4.2, details: "" )),
        (Star(hipId: 113368, enName: "Fomalhaut", jpName: "フォーマルハウト", rightAscension: 22.573883, declination: -29.37186, magnitude: 1.17, details: "" )),
        (Star(hipId: 113638, enName: "", jpName: "", rightAscension: 23.05287, declination: -52.45148, magnitude: 4.11, details: "" )),
        (Star(hipId: 113881, enName: "Scheat", jpName: "シェアト", rightAscension: 23.34633, declination: 28.4568, magnitude: 2.44, details: "" )),
        (Star(hipId: 113963, enName: "Markab", jpName: "マルカブ", rightAscension: 23.44562, declination: 15.12193, magnitude: 2.49, details: "" )),
        (Star(hipId: 114131, enName: "", jpName: "", rightAscension: 23.65277, declination: -43.31132, magnitude: 4.28, details: "" )),
        (Star(hipId: 114341, enName: "", jpName: "", rightAscension: 23.92676, declination: -21.10209, magnitude: 3.68, details: "" )),
        (Star(hipId: 114421, enName: "", jpName: "", rightAscension: 23.102143, declination: -45.14479, magnitude: 3.88, details: "" )),
        (Star(hipId: 114855, enName: "", jpName: "", rightAscension: 23.155328, declination: -9.5157, magnitude: 4.24, details: "" )),
        (Star(hipId: 114971, enName: "", jpName: "", rightAscension: 23.17949, declination: 3.16561, magnitude: 3.7, details: "" )),
        (Star(hipId: 114996, enName: "", jpName: "", rightAscension: 23.172581, declination: -58.1493, magnitude: 3.99, details: "" )),
        (Star(hipId: 115102, enName: "", jpName: "", rightAscension: 23.184943, declination: -32.31546, magnitude: 4.41, details: "" )),
        (Star(hipId: 115438, enName: "", jpName: "", rightAscension: 23.22583, declination: -20.612, magnitude: 3.96, details: "" )),
        (Star(hipId: 115738, enName: "", jpName: "", rightAscension: 23.265591, declination: 1.1521, magnitude: 4.95, details: "" )),
        (Star(hipId: 115830, enName: "", jpName: "", rightAscension: 23.275817, declination: 6.22448, magnitude: 4.27, details: "" )),
        (Star(hipId: 116231, enName: "", jpName: "", rightAscension: 23.325819, declination: -37.4961, magnitude: 4.38, details: "" )),
        (Star(hipId: 116727, enName: "", jpName: "", rightAscension: 23.392098, declination: 77.37551, magnitude: 3.21, details: "" )),
        (Star(hipId: 116771, enName: "", jpName: "", rightAscension: 23.395682, declination: 5.37385, magnitude: 4.13, details: "" )),
        (Star(hipId: 116928, enName: "", jpName: "", rightAscension: 23.42288, declination: 1.46495, magnitude: 4.49, details: "" )),
        (Star(hipId: 118268, enName: "", jpName: "", rightAscension: 23.59186, declination: 6.51489, magnitude: 4.03, details: "" ))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starIntroView()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        // 現在地を取得
        setupLocationManager()
        
        // 星表示(仮)
        //setStar(starPosition: starPosition)

        //BGM再生
        playSound(name: "star_bgm")
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
        let filter:CIFilter = CIFilter(name: "CIDotScreen")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
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
        
        // フォント設定
        firstIntro.titleFont = UIFont(name: "HelveticaNeue-Bold", size: 45)
        firstIntro.descFont = UIFont(name:"HelveticaNeue-Light",size:15)
        secondIntro.descFont = UIFont(name:"HelveticaNeue-Light",size:15)
        secondIntro.titleFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
        
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [firstIntro,secondIntro])
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
//            test
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
            let starRight = floor(stars[index].magnitude)
            if starRight <= 1 {
                material.diffuse.contents = UIImage(named: "art.scnassets/1等星.png")
            }else if starRight == 2 {
                material.diffuse.contents = UIImage(named: "art.scnassets/2等星.png")
            }else if starRight == 3 {
                material.diffuse.contents = UIImage(named: "art.scnassets/3等星.png")
            }else if starRight == 4 {
                material.diffuse.contents = UIImage(named: "art.scnassets/4等星.png")
            }else{
                material.diffuse.contents = UIImage(named: "art.scnassets/5等星.png")
            }
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
            let textNode = SCNNode(geometry: text)
            let (min, max) = (textNode.boundingBox)
            let x = CGFloat(max.x - min.x)
//            let y = CGFloat(max.y - min.y)
//            let v = element[3] * (Double.pi / 180)
            if 0...45 ~= element[4] || 315...360 ~= element[4] {
                let z = 180 * (Double.pi / 180)
                textNode.eulerAngles = SCNVector3(0,z,0)
            }else if 45...135 ~= element[4] {
                let z = 90 * (Double.pi / -180)
                textNode.eulerAngles = SCNVector3(0,z,0)
            }else if 135...225 ~= element[4] {
                textNode.eulerAngles = SCNVector3(0,0,0)
            }else if 225...315 ~= element[4] {
                let z = 90 * (Double.pi / 180)
                textNode.eulerAngles = SCNVector3(0,z,0)
            }
            textNode.position = SCNVector3((element[0] - Double(x)),element[1],element[2])
            
//            print("textNode",textNode.eulerAngles)
            sceneView.scene.rootNode.addChildNode(textNode)
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
