//
//  ZooModalViewController.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/09/22.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ZooModalViewController: UIViewController, UIScrollViewDelegate {

    private var pageControl: UIPageControl!
    private var scrollView: UIScrollView!

    let zebraImage:UIImage = UIImage(named:"ZooImage/Zebra")!
    let unicornImage:UIImage = UIImage(named:"ZooImage/Unicorn")!

    
    // ボタン配置変数
    var prevButton:CGFloat = 20
    
    // ボタンの横幅、縦幅設定定数
    let buttonWidth:CGFloat = 180
    let buttonHeight:CGFloat = 180
    
    // 画面の横幅、縦幅
    let width:CGFloat = UIScreen.main.bounds.size.width
    let height:CGFloat = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = 6
        
        //UIScrollViewの設定
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        //scrollViewのサイズ。4ページなので、画面幅 × 3をしている。
        scrollView.contentSize = CGSize(width: CGFloat(page) * width, height: 0)
        
        self.view.addSubview(scrollView)
        
        //ページごとのlabelを生成
        for i in 0 ..< page {
            let label:UILabel = UILabel()
            label.frame = CGRect(x: CGFloat(i) * width + width/2 - 60, y: height/2 - 300, width: 130, height: 80)
            label.textAlignment = NSTextAlignment.center
            // フォントサイズ
            label.font = UIFont.systemFont(ofSize: 36)
            
            
            if i == 0{

                //Zebra
                //label.text = "Zebra"
                //scrollView.addSubview(label)
                // 影表示用のビュー
                let zebraShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
                prevButton = buttonHeight / 2 + 250
                zebraShadowView.center = CGPoint(x: width  / 2 - 95, y: prevButton - 240)
                zebraShadowView.layer.shadowColor = UIColor.black.cgColor
                zebraShadowView.layer.shadowOpacity = 0.5
                zebraShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
                zebraShadowView.layer.shadowRadius = 5
                // 画像ボタン
                let zebraButton = UIButton(frame: zebraShadowView.bounds)
                zebraButton.setBackgroundImage(zebraImage, for: [])
                zebraButton.layer.cornerRadius = 12
                zebraButton.layer.masksToBounds = true
                // 影表示用のビューに画像ボタンを乗せる
                zebraShadowView.addSubview(zebraButton)
                // 影表示+画像ボタンのビューを乗せる
                scrollView.addSubview(zebraShadowView)

                //Unicorn
                //label.text = "Unicorn"
                //scrollView.addSubview(label)
                // 影表示用のビュー
                let unicornShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
                prevButton = buttonHeight / 2 + 250
                unicornShadowView.center = CGPoint(x: width  / 2 + 95, y: prevButton - 240)
                unicornShadowView.layer.shadowColor = UIColor.black.cgColor
                unicornShadowView.layer.shadowOpacity = 0.5
                unicornShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
                unicornShadowView.layer.shadowRadius = 5
                // 画像ボタン
                let unicornButton = UIButton(frame: unicornShadowView.bounds)
                unicornButton.setBackgroundImage(unicornImage, for: [])
                unicornButton.layer.cornerRadius = 12
                unicornButton.layer.masksToBounds = true
                // 影表示用のビューに画像ボタンを乗せる
                unicornShadowView.addSubview(unicornButton)
                // 影表示+画像ボタンのビューを乗せる
                scrollView.addSubview(unicornShadowView)
                
                
                //Sheep
                //label.text = "Sheep"
                //scrollView.addSubview(label)
                // 影表示用のビュー
                let sheepShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
                prevButton = buttonHeight / 2 + 250
                sheepShadowView.center = CGPoint(x: width  / 2 - 95, y: prevButton - 55)
                sheepShadowView.layer.shadowColor = UIColor.black.cgColor
                sheepShadowView.layer.shadowOpacity = 0.5
                sheepShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
                sheepShadowView.layer.shadowRadius = 5
                // 画像ボタン
                let sheepButton = UIButton(frame: sheepShadowView.bounds)
                sheepButton.setBackgroundImage(zebraImage, for: [])
                sheepButton.layer.cornerRadius = 12
                sheepButton.layer.masksToBounds = true
                // 影表示用のビューに画像ボタンを乗せる
                sheepShadowView.addSubview(sheepButton)
                // 影表示+画像ボタンのビューを乗せる
                scrollView.addSubview(sheepShadowView)
                
                
                //Hippopotamus
                //label.text = "Hippopotamus"
                //scrollView.addSubview(label)
                // 影表示用のビュー
                let HippopotamusShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
                prevButton = buttonHeight / 2 + 250
                HippopotamusShadowView.center = CGPoint(x: width  / 2 + 95, y: prevButton - 55)
                HippopotamusShadowView.layer.shadowColor = UIColor.black.cgColor
                HippopotamusShadowView.layer.shadowOpacity = 0.5
                HippopotamusShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
                HippopotamusShadowView.layer.shadowRadius = 5
                // 画像ボタン
                let HippopotamusButton = UIButton(frame: HippopotamusShadowView.bounds)
                HippopotamusButton.setBackgroundImage(zebraImage, for: [])
                HippopotamusButton.layer.cornerRadius = 12
                HippopotamusButton.layer.masksToBounds = true
                // 影表示用のビューに画像ボタンを乗せる
                HippopotamusShadowView.addSubview(HippopotamusButton)
                // 影表示+画像ボタンのビューを乗せる
                scrollView.addSubview(HippopotamusShadowView)
/*
                let button1 = UIButton()
                button1.frame = CGRect(x:0, y:0,
                                      width:buttonWidth, height:buttonHeight)
                prevButton = buttonHeight / 2 + 250
                button1.center = CGPoint(x: width  / 2 - 95, y: prevButton - 240)
                button1.setBackgroundImage(zebraImage, for: [])
                scrollView.addSubview(button1)
                
                let button2 = UIButton()
                button2.frame = CGRect(x:0, y:0,
                                       width:buttonWidth, height:buttonHeight)
                prevButton = buttonHeight / 2 + 250
                button2.center = CGPoint(x: width  / 2 + 95, y: prevButton - 240)
                button2.setBackgroundImage(zebraImage, for: [])
                scrollView.addSubview(button2)
                
                let button3 = UIButton()
                button3.frame = CGRect(x:0, y:0,
                                       width:buttonWidth, height:buttonHeight)
                prevButton = buttonHeight / 2 + 250
                button3.center = CGPoint(x: width  / 2 - 95, y: prevButton - 50)
                button3.setBackgroundImage(zebraImage, for: [])
                scrollView.addSubview(button3)
                
                let button4 = UIButton()
                button4.frame = CGRect(x:0, y:0,
                                       width:buttonWidth, height:buttonHeight)
                prevButton = buttonHeight / 2 + 250
                button4.center = CGPoint(x: width  / 2 + 95, y: prevButton - 50)
                button4.setBackgroundImage(zebraImage, for: [])
                scrollView.addSubview(button4)
                
*/
                
                
                
            }else if i == 1{
/*
                //Zebra
                //label.text = "Zebra"
                //scrollView.addSubview(label)
                // 影表示用のビュー
                let zebraShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
                prevButton = buttonHeight / 2 + 250
                zebraShadowView.center = CGPoint(x: width  / 2 - 100, y: prevButton - 150)
                zebraShadowView.layer.shadowColor = UIColor.black.cgColor
                zebraShadowView.layer.shadowOpacity = 0.5
                zebraShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
                zebraShadowView.layer.shadowRadius = 5
                // 画像ボタン
                let zebraButton = UIButton(frame: zebraShadowView.bounds)
                zebraButton.setBackgroundImage(gorillaGifImage, for: [])
                zebraButton.layer.cornerRadius = 12
                zebraButton.layer.masksToBounds = true
                // 影表示用のビューに画像ボタンを乗せる
                zebraShadowView.addSubview(zebraButton)
                // 影表示+画像ボタンのビューを乗せる
                scrollView.addSubview(zebraShadowView)
*/
            }
        }
        
        //UIPageControlのインスタンス作成
        pageControl = UIPageControl()
        
        //pageControlの位置とサイズを設定
        pageControl.frame = CGRect(x:0, y:height - 170, width:width, height:50)
        
        // インジケータの色合い
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 56/255, green: 151/255, blue: 240/255, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor.init(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0)
        
        //ページ数の設定
        pageControl.numberOfPages = page
        
        //現在ページの設定
        pageControl.currentPage = 0
        
        
        self.view.addSubview(pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //スクロール距離 = 1ページ(画面幅)
        if fmod(scrollView.contentOffset.x, scrollView.frame.width) == 0 {
            //ページの切り替え
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        }
    }

}
