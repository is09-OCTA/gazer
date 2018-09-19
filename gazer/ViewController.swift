//
//  ViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/05/18.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ViewController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDelegate, UIGestureRecognizerDelegate{

    // ボタンの横幅、縦幅設定定数
    let buttonWidth:CGFloat = UIScreen.main.bounds.size.width * 0.9
    let buttonHeight:CGFloat = UIScreen.main.bounds.size.width * 1.08

    // ボタン配置変数
    var prevButton:CGFloat = 20
    
    // gazerヘッダー高さ
    let gazerHedder:CGFloat = 50
    
    // ボタン画像の読み込み
    let starButtonImage:UIImage = UIImage(named: "StarButton002")!
    let mappingButtonImage:UIImage = UIImage(named:"ZooButton001")!
    let aquariumButtonImage:UIImage = UIImage(named:"AquariumButton007")!
    let zooButtonImage:UIImage = UIImage(named: "ZooButton001")!
    
    let starButtonGifImage = UIImage.gif(name:"gif/aquarium_ver5")
    let mappingButtonGifImage = UIImage.gif(name:"gif/aquarium_ver5")
    let zooButtonGifImage = UIImage.gif(name:"gif/zoo_ver1")
    let aquariumButtonGifImage = UIImage.gif(name:"gif/aquarium_ver5")

    // 画面の横幅、縦幅
    let screenWidth:CGFloat = UIScreen.main.bounds.size.width
    let screenHeight:CGFloat = UIScreen.main.bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scrollViewの生成
        let scrollView = UIScrollView()
        // 表示窓のサイズと位置を設定
        scrollView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        scrollView.frame = CGRect(x:0,y:gazerHedder,width:screenWidth,height:screenHeight)
        // scrollView中身の大きさを設定
        scrollView.contentSize = CGSize(width: buttonWidth, height: gazerHedder+buttonHeight * 4.5)
        // scrollViewの跳ね返り
        scrollView.bounces = true
        // Barの見た目と余白
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        // View追加
        view.addSubview(scrollView)
        // Delegateを設定
        scrollView.delegate = self
        
        // ScrollViewの中身
        
        // starButton
        // 影表示用のビュー
        let starShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        prevButton += buttonHeight / 2
        starShadowView.center = CGPoint(x: screenWidth / 2, y: prevButton)
        starShadowView.layer.shadowColor = UIColor.black.cgColor
        starShadowView.layer.shadowOpacity = 0.5
        starShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        starShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let starButton = UIButton(frame: starShadowView.bounds)
        starButton.setBackgroundImage(zooButtonGifImage, for: [])
        starButton.layer.cornerRadius = 12
        starButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        starShadowView.addSubview(starButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(starShadowView)
        
        // mappingButton
        // 影表示用のビュー
        let mappingShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        prevButton += buttonHeight * 1.1
        mappingShadowView.center = CGPoint(x: screenWidth / 2, y: prevButton)
        mappingShadowView.layer.shadowColor = UIColor.black.cgColor
        mappingShadowView.layer.shadowOpacity = 0.5
        mappingShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mappingShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let mappingButton = UIButton(frame: mappingShadowView.bounds)
        mappingButton.setBackgroundImage(zooButtonGifImage, for: [])
        mappingButton.layer.cornerRadius = 12
        mappingButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        mappingShadowView.addSubview(mappingButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(mappingShadowView)
        
        // aquariumButton
        // 影表示用のビュー
        let aquariumShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        prevButton += buttonHeight * 1.1
        aquariumShadowView.center = CGPoint(x: screenWidth / 2, y: prevButton)
        aquariumShadowView.layer.shadowColor = UIColor.black.cgColor
        aquariumShadowView.layer.shadowOpacity = 0.5
        aquariumShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        aquariumShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let aquariumButton = UIButton(frame: aquariumShadowView.bounds)
        aquariumButton.setBackgroundImage(zooButtonGifImage, for: [])
        aquariumButton.layer.cornerRadius = 12
        aquariumButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        aquariumShadowView.addSubview(aquariumButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(aquariumShadowView)
        
        // zooButton
        let zooShadowView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight ))
        prevButton += buttonHeight * 1.1
        zooShadowView.center = CGPoint(x: screenWidth / 2, y: prevButton)
        zooShadowView.layer.shadowColor = UIColor.black.cgColor
        zooShadowView.layer.shadowOpacity = 0.5
        zooShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        zooShadowView.layer.shadowRadius = 5
        // 画像ボタン
        let zooButton = UIButton(frame: zooShadowView.bounds)
        zooButton.setBackgroundImage(zooButtonGifImage, for: [])
        zooButton.layer.cornerRadius = 12
        zooButton.layer.masksToBounds = true
        // 影表示用のビューに画像ボタンを乗せる
        zooShadowView.addSubview(zooButton)
        // 影表示+画像ボタンのビューを乗せる
        scrollView.addSubview(zooShadowView)
        
        // ボタンを押された時のフロー
        starButton.addTarget(self, action: (#selector(ViewController.goStarAction)), for:.touchUpInside)
        mappingButton.addTarget(self, action: (#selector(ViewController.goMappingAction)), for:.touchUpInside)
        aquariumButton.addTarget(self, action: (#selector(ViewController.goAquariumAction)), for:.touchUpInside)
        zooButton.addTarget(self, action: (#selector(ViewController.goZooAction)), for:.touchUpInside)
    }
    
    // Star画面遷移
    @objc func goStarAction(sender: UIButton){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.04
        animation.toValue = 1.0
        animation.mass = 1.0
        animation.initialVelocity = 10.0
        animation.damping = 3.0
        animation.stiffness = 200.0
        sender.layer.add(animation, forKey: nil)

        performSegue(withIdentifier: "goStar", sender: nil)
    }
    
    // Mapping画面遷移
    @objc func goMappingAction(sender: UIButton){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.04
        animation.toValue = 1.0
        animation.mass = 1.0
        animation.initialVelocity = 10.0
        animation.damping = 3.0
        animation.stiffness = 200.0
        sender.layer.add(animation, forKey: nil)
        
       performSegue(withIdentifier: "goMapping", sender: nil)
    }

    
    // Aquarium画面遷移
    @objc func goAquariumAction(sender: UIButton){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.04
        animation.toValue = 1.0
        animation.mass = 1.0
        animation.initialVelocity = 10.0
        animation.damping = 3.0
        animation.stiffness = 200.0
        sender.layer.add(animation, forKey: nil)
        
        performSegue(withIdentifier: "goAquarium", sender: nil)
    }
    
    // Zoo画面遷移
    @objc func goZooAction(sender: UIButton){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.04
        animation.toValue = 1.0
        animation.mass = 1.0
        animation.initialVelocity = 10.0
        animation.damping = 3.0
        animation.stiffness = 200.0
        sender.layer.add(animation, forKey: nil)
        
        performSegue(withIdentifier: "goZoo", sender: nil)
    }

    
    
}
