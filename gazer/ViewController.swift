//
//  ViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/05/18.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate{

    //ボタンの横幅、縦幅設定変数
    var buttonWidth:CGFloat = 0
    var buttonHeight:CGFloat = 0
    
    //ボタン画像の読み込み
    let starButtonImage:UIImage = UIImage(named: "STAR_ver 1.3.2")!
    let testStarButtonImage:UIImage = UIImage(named: "STAR_ver 1.3.3")!
    
    //画面の横幅、縦幅取得する変数
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンの横幅、縦幅設定
        buttonWidth = 375
        buttonHeight = 200
        
        //画面の横幅、縦幅の取得
        screenWidth = view.frame.width
        screenHeight = view.frame.height
        
        
        //scrollViewの作成
        let scrollView = UIScrollView()
        
        // 表示窓のサイズと位置を設定
        //scrollView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        scrollView.frame = CGRect(x:0,y:50,width:screenWidth,height:screenHeight)
        
        // 中身の大きさを設定
        scrollView.contentSize = CGSize(width: buttonWidth, height: buttonHeight*4)
        
        // スクロールの跳ね返り
        scrollView.bounces = true
        
        // スクロールバーの見た目と余白
        scrollView.indicatorStyle = .black
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Delegate を設定
        scrollView.delegate = self
        
        // ScrollViewの中身
        
        //StarButton
        let starButton = UIButton()
        starButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        starButton.setImage(starButtonImage, for: UIControlState())
        starButton.center = CGPoint(x: screenWidth/2, y: 100)
        scrollView.addSubview(starButton)
        self.view.addSubview(scrollView)
        
        //test
        let testButton = UIButton()
        testButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        testButton.setImage(testStarButtonImage, for: UIControlState())
        testButton.center = CGPoint(x: screenWidth/2, y: 150*2)
        scrollView.addSubview(testButton)
        self.view.addSubview(scrollView)
        
        //ボタンを押された時のフロー
        starButton.addTarget(self, action: (#selector(ViewController.goStarAction)), for:.touchUpInside)
    }

    @objc func goStarAction(){
        performSegue(withIdentifier: "goStar", sender: nil)
    }

}
