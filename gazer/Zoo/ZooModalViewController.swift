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
    
    // 画面の横幅、縦幅
    var width:CGFloat = UIScreen.main.bounds.size.width
    let height:CGFloat = UIScreen.main.bounds.size.height
    
    // ボタンの画像
    let zebraImage:UIImage = UIImage(named:"ZooImage/Zebra")!
    let unicornImage:UIImage = UIImage(named:"ZooImage/Unicorn")!
    let sheepImage:UIImage = UIImage(named: "ZooImage/Sheep")!
    let hippopotamusImage:UIImage = UIImage(named: "ZooImage/Hippopotamus")!
    let gorillaImage:UIImage = UIImage(named: "ZooImage/Gorilla")!
    let elkImage:UIImage = UIImage(named: "ZooImage/Elk")!
    let alligatorImage:UIImage = UIImage(named: "ZooImage/Aligator")!
    let snakeImage:UIImage = UIImage(named: "ZooImage/Snake")!
    let pandaImage:UIImage = UIImage(named: "ZooImage/Panda")!
    let greatEgretImage:UIImage = UIImage(named: "ZooImage/GreatEgret")!
    let koalaImage:UIImage = UIImage(named: "ZooImage/Koala")!
    let kangarooImage:UIImage = UIImage(named: "ZooImage/Kangaroo")!
    let lionImage:UIImage = UIImage(named: "ZooImage/Lion")!
    let antelopeImage:UIImage = UIImage(named: "ZooImage/Antelope")!
    let cowImage:UIImage = UIImage(named: "ZooImage/Cow")!
    let giraffeImage:UIImage = UIImage(named: "ZooImage/Giraffe")!
    let hedgehogImage:UIImage = UIImage(named: "ZooImage/Hedgehog")!
    let rhinocerosImage:UIImage = UIImage(named: "ZooImage/Rhinoceros")!
    let cottontailRabbitImage:UIImage = UIImage(named: "ZooImage/CottontailRabbit")!
    let tRexImage:UIImage = UIImage(named: "ZooImage/T-Rex")!
     let dogImage:UIImage = UIImage(named: "ZooImage/Dog")!
     let catImage:UIImage = UIImage(named: "ZooImage/Cat")!
     let batImage:UIImage = UIImage(named: "ZooImage/Bat")!
     let elephantImage:UIImage = UIImage(named: "ZooImage/Elephant")!
     let chimpanzeeImage:UIImage = UIImage(named: "ZooImage/Chimpanzee")!
    

    
    // ボタン配置変数
    var prevButton:CGFloat = 20
    
    // ボタンの辺の長さ
    let buttonSide:CGFloat = (UIScreen.main.bounds.size.width * 12) / 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = 7
        
        //UIScrollViewの設定
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        //scrollViewのサイズ。4ページなので、画面幅 × page(数)をしている。
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

                // 左上
                let zebraButton = UIButton()
                zebraButton.setBackgroundImage(zebraImage, for: [])
                zebraButton.layer.cornerRadius = 5
                zebraButton.layer.masksToBounds  = true
                zebraButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(zebraButton)
                
                // 右上
                let unicornButton = UIButton()
                unicornButton.setBackgroundImage(unicornImage, for: [])
                unicornButton.layer.cornerRadius = 5
                unicornButton.layer.masksToBounds  = true
                unicornButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(unicornButton)
                
                // 左下
                let sheepButton = UIButton()
                sheepButton.setBackgroundImage(sheepImage, for: [])
                sheepButton.layer.cornerRadius = 5
                sheepButton.layer.masksToBounds  = true
                sheepButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 6 + buttonSide,
                                             width: buttonSide, height: buttonSide)
                scrollView.addSubview(sheepButton)

                // 右下
                let hippopotamusButton = UIButton()
                hippopotamusButton.setBackgroundImage(hippopotamusImage, for: [])
                hippopotamusButton.layer.cornerRadius = 5
                hippopotamusButton.layer.masksToBounds  = true
                hippopotamusButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(hippopotamusButton)
                
            } else if i == 1 {
                
                let widthPage = width
                
                // 左上
                let gorillaButton = UIButton()
                gorillaButton.setBackgroundImage(gorillaImage, for: [])
                gorillaButton.layer.cornerRadius = 5
                gorillaButton.layer.masksToBounds  = true
                gorillaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(gorillaButton)
                
                // 右上
                let elkButton = UIButton()
                elkButton.setBackgroundImage(elkImage, for: [])
                elkButton.layer.cornerRadius = 5
                elkButton.layer.masksToBounds  = true
                elkButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4,
                                             width: buttonSide, height: buttonSide)
                scrollView.addSubview(elkButton)
                
                // 左下
                let alligatorButton = UIButton()
                alligatorButton.setBackgroundImage(alligatorImage, for: [])
                alligatorButton.layer.cornerRadius = 5
                alligatorButton.layer.masksToBounds  = true
                alligatorButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(alligatorButton)
                
                // 右下
                let snakeButton = UIButton()
                snakeButton.setBackgroundImage(snakeImage, for: [])
                snakeButton.layer.cornerRadius = 5
                snakeButton.layer.masksToBounds  = true
                snakeButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide,
                                                  width: buttonSide, height: buttonSide)
                scrollView.addSubview(snakeButton)
            }  else if i == 2 {
                
                let widthPage = width * 2
                
                // 左上
                let pandaButton = UIButton()
                pandaButton.setBackgroundImage(pandaImage, for: [])
                pandaButton.layer.cornerRadius = 5
                pandaButton.layer.masksToBounds  = true
                pandaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                             width: buttonSide, height: buttonSide)
                scrollView.addSubview(pandaButton)
                
                // 右上
                let greatEgretButton = UIButton()
                greatEgretButton.setBackgroundImage(greatEgretImage, for: [])
                greatEgretButton.layer.cornerRadius = 5
                greatEgretButton.layer.masksToBounds  = true
                greatEgretButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4,
                                         width: buttonSide, height: buttonSide)
                scrollView.addSubview(greatEgretButton)
                
                // 左下
                let koalaButton = UIButton()
                koalaButton.setBackgroundImage(koalaImage, for: [])
                koalaButton.layer.cornerRadius = 5
                koalaButton.layer.masksToBounds  = true
                koalaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide,
                                               width: buttonSide, height: buttonSide)
                scrollView.addSubview(koalaButton)
                
                // 右下
                let kangarooButton = UIButton()
                kangarooButton.setBackgroundImage(kangarooImage, for: [])
                kangarooButton.layer.cornerRadius = 5
                kangarooButton.layer.masksToBounds  = true
                kangarooButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(kangarooButton)
            }  else if i == 3 {
                
                let widthPage = width * 3
                
                // 左上
                let lionButton = UIButton()
                lionButton.setBackgroundImage(lionImage, for: [])
                lionButton.layer.cornerRadius = 5
                lionButton.layer.masksToBounds  = true
                lionButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(lionButton)
                
                // 右上
                let antelopeButton = UIButton()
                antelopeButton.setBackgroundImage(antelopeImage, for: [])
                antelopeButton.layer.cornerRadius = 5
                antelopeButton.layer.masksToBounds  = true
                antelopeButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(antelopeButton)
                
                // 左下
                let cowButton = UIButton()
                cowButton.setBackgroundImage(cowImage, for: [])
                cowButton.layer.cornerRadius = 5
                cowButton.layer.masksToBounds  = true
                cowButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide,
                                            width: buttonSide, height: buttonSide)
                scrollView.addSubview(cowButton)
                
                // 右下
                let giraffeButton = UIButton()
                giraffeButton.setBackgroundImage(giraffeImage, for: [])
                giraffeButton.layer.cornerRadius = 5
                giraffeButton.layer.masksToBounds  = true
                giraffeButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(giraffeButton)
            }  else if i == 4 {
                
                let widthPage = width * 4
                
                // 左上
                let hedgehogButton = UIButton()
                hedgehogButton.setBackgroundImage(hedgehogImage, for: [])
                hedgehogButton.layer.cornerRadius = 5
                hedgehogButton.layer.masksToBounds  = true
                hedgehogButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(hedgehogButton)
                
                // 右上
                let rhinocerosButton = UIButton()
                rhinocerosButton.setBackgroundImage(rhinocerosImage, for: [])
                rhinocerosButton.layer.cornerRadius = 5
                rhinocerosButton.layer.masksToBounds  = true
                rhinocerosButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(rhinocerosButton)
                
                // 左下
                let tRexButton = UIButton()
                tRexButton.setBackgroundImage(tRexImage, for: [])
                tRexButton.layer.cornerRadius = 5
                tRexButton.layer.masksToBounds  = true
                tRexButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide,
                                            width: buttonSide, height: buttonSide)
                scrollView.addSubview(tRexButton)
                
                // 右下
                let dogButton = UIButton()
                dogButton.setBackgroundImage(dogImage, for: [])
                dogButton.layer.cornerRadius = 5
                dogButton.layer.masksToBounds  = true
                dogButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(dogButton)
            }  else if i == 5 {
                
                let widthPage = width * 5
                
                // 左上
                let cottontailRabbitButton = UIButton()
                cottontailRabbitButton.setBackgroundImage(cottontailRabbitImage, for: [])
                cottontailRabbitButton.layer.cornerRadius = 5
                cottontailRabbitButton.layer.masksToBounds  = true
                cottontailRabbitButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(cottontailRabbitButton)
                
                // 右上
                let catButton = UIButton()
                catButton.setBackgroundImage(catImage, for: [])
                catButton.layer.cornerRadius = 5
                catButton.layer.masksToBounds  = true
                catButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(catButton)
                
                // 左下
                let batButton = UIButton()
                batButton.setBackgroundImage(batImage, for: [])
                batButton.layer.cornerRadius = 5
                batButton.layer.masksToBounds  = true
                batButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(batButton)
                
                // 右下
                let elephantButton = UIButton()
                elephantButton.setBackgroundImage(elephantImage, for: [])
                elephantButton.layer.cornerRadius = 5
                elephantButton.layer.masksToBounds  = true
                elephantButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(elephantButton)
            }else if i == 6 {
                
                let widthPage = width * 6
                
                // 左上
                let chimpanzeeButton = UIButton()
                chimpanzeeButton.setBackgroundImage(chimpanzeeImage, for: [])
                chimpanzeeButton.layer.cornerRadius = 5
                chimpanzeeButton.layer.masksToBounds  = true
                chimpanzeeButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(chimpanzeeButton)
            }
        }
        
        //UIPageControlのインスタンス作成
        pageControl = UIPageControl()
        
        //pageControlの位置とサイズを設定
        pageControl.frame = CGRect(x: 0, y: height / 1.7, width: width, height: 50)
        
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
