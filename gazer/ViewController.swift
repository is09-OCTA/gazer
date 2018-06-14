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
        scrollView.contentSize = CGSize(width: buttonWidth, height: gazerHedder+buttonHeight*4+40)
        
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
        // StarButton
        let starButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        starButton.setImage(starButtonImage, for: UIControlState())
        starButton.center = CGPoint(x: screenWidth/2, y: 100)
        starButton.layer.cornerRadius = starButton.frame.size.width * 0.1
        starButton.clipsToBounds = true
        scrollView.addSubview(starButton)
        
        // mappingButton
        let mappingButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        mappingButton.setImage(mappingButtonImage, for: UIControlState())
        mappingButton.center = CGPoint(x: screenWidth/2, y: 300+10)
        mappingButton.layer.cornerRadius = mappingButton.frame.size.width * 0.1
        mappingButton.clipsToBounds = true
        scrollView.addSubview(mappingButton)
        
        // aquariumButton
        let aquariumButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        aquariumButton.setImage(aquariumButtonImage, for: UIControlState())
        aquariumButton.center = CGPoint(x: screenWidth/2, y: 500+20)
        aquariumButton.layer.cornerRadius = aquariumButton.frame.size.width * 0.1
        aquariumButton.clipsToBounds = true
        scrollView.addSubview(aquariumButton)
        
        // zooButton
        let zooButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        zooButton.setImage(zooButtonImage, for: UIControlState())
        zooButton.center = CGPoint(x: screenWidth/2, y: 700+30)
        zooButton.layer.cornerRadius = zooButton.frame.size.width * 0.1
        zooButton.clipsToBounds = true
        scrollView.addSubview(zooButton)

        // ボタンを押された時のフロー
        starButton.addTarget(self, action: (#selector(ViewController.goStarAction)), for:.touchUpInside)
    }
    // Star画面遷移
    @objc func goStarAction(){
        performSegue(withIdentifier: "goStar", sender: nil)
    }

}
