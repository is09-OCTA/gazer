//
//  ViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/05/18.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDelegate, UIGestureRecognizerDelegate{

    // ボタンの横幅、縦幅設定変数
    var buttonWidth:CGFloat = 0
    var buttonHeight:CGFloat = 0
    
    // gazerヘッダー高さ
    var gazerHedder:CGFloat = 0
    
    // ボタン画像の読み込み
    let starButtonImage:UIImage = UIImage(named: "StarVer1.3.8")!
    let mappingButtonImage:UIImage = UIImage(named:"MappingVer1.2.0")!
    let aquariumButtonImage:UIImage = UIImage(named:"AquariumVer1.2.0")!
    let zooButtonImage:UIImage = UIImage(named: "ZooVer1.2.0")!

    // 画面の横幅、縦幅取得する変数
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンの横幅、縦幅設定
        buttonWidth = 360
        buttonHeight = 200
        
        // gazerヘッダー高さ
        gazerHedder = 50
        
        // 画面の横幅、縦幅の取得
        screenWidth = view.frame.width
        screenHeight = view.frame.height
        
        // scrollViewの作成
        let scrollView = UIScrollView()
        
        // 表示窓のサイズと位置を設定
        scrollView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        scrollView.frame = CGRect(x:0,y:gazerHedder,width:screenWidth,height:screenHeight)
        
        // スクロール中身の大きさを設定
        scrollView.contentSize = CGSize(width: buttonWidth, height: gazerHedder+buttonHeight * 4 + 80)
        
        // スクロールの跳ね返り
        scrollView.bounces = true
        
        // スクロールバーの見た目と余白
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    
        // ビュー追加
        view.addSubview(scrollView)
        
        // Delegate を設定
        scrollView.delegate = self
    
        // ScrollViewの中身
        
        // starButton
        // 影表示用のビュー
        let starShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        starShadowView.center = CGPoint(x: screenWidth / 2, y: 100)
        starShadowView.layer.shadowColor = UIColor.black.cgColor
        starShadowView.layer.shadowOpacity = 0.5
        starShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        starShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let starButton = UIButton(frame: starShadowView.bounds)
        starButton.setBackgroundImage(starButtonImage, for: [])
        starButton.layer.cornerRadius = 12
        starButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        starShadowView.addSubview(starButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(starShadowView)
        
        // mappingButton
        // 影表示用のビュー
        let mappingShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        mappingShadowView.center = CGPoint(x: screenWidth / 2, y: 300 + 20)
        mappingShadowView.layer.shadowColor = UIColor.black.cgColor
        mappingShadowView.layer.shadowOpacity = 0.5
        mappingShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mappingShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let mappingButton = UIButton(frame: mappingShadowView.bounds)
        mappingButton.setBackgroundImage(mappingButtonImage, for: [])
        mappingButton.layer.cornerRadius = 12
        mappingButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        mappingShadowView.addSubview(mappingButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(mappingShadowView)
        
        // aquariumButton
        // 影表示用のビュー
        let aquariumShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        aquariumShadowView.center = CGPoint(x: screenWidth / 2, y: 500 + 40)
        aquariumShadowView.layer.shadowColor = UIColor.black.cgColor
        aquariumShadowView.layer.shadowOpacity = 0.5
        aquariumShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        aquariumShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let aquariumButton = UIButton(frame: aquariumShadowView.bounds)
        aquariumButton.setBackgroundImage(aquariumButtonImage, for: [])
        aquariumButton.layer.cornerRadius = 12
        aquariumButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        aquariumShadowView.addSubview(aquariumButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(aquariumShadowView)
        
        // zooButton
        let zooShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        zooShadowView.center = CGPoint(x: screenWidth / 2, y: 700 + 60)
        zooShadowView.layer.shadowColor = UIColor.black.cgColor
        zooShadowView.layer.shadowOpacity = 0.5
        zooShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        zooShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let zooButton = UIButton(frame: zooShadowView.bounds)
        zooButton.setBackgroundImage(zooButtonImage, for: [])
        zooButton.layer.cornerRadius = 12
        zooButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        zooShadowView.addSubview(zooButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(zooShadowView)

        // ボタンを押された時のフロー
        starButton.addTarget(self, action: (#selector(ViewController.goStarAction)), for:.touchUpInside)
    }
    // Star画面遷移
    @objc func goStarAction(){
        performSegue(withIdentifier: "goStar", sender: nil)
    }

}
