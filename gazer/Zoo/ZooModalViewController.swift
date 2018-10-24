//
//  ZooModalViewController.swift
//  gazer
//
//  Created by Keisuke Kitamura on 2018/09/22.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit

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
                zebraButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                zebraButton.setTitle("Zebra", for: .disabled)
                scrollView.addSubview(zebraButton)

                zebraButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let unicornButton = UIButton()
                unicornButton.setBackgroundImage(unicornImage, for: [])
                unicornButton.layer.cornerRadius = 5
                unicornButton.layer.masksToBounds  = true
                unicornButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                unicornButton.setTitle("Unicorn", for: .disabled)
                scrollView.addSubview(unicornButton)
                
                unicornButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let sheepButton = UIButton()
                sheepButton.setBackgroundImage(sheepImage, for: [])
                sheepButton.layer.cornerRadius = 5
                sheepButton.layer.masksToBounds  = true
                sheepButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                sheepButton.setTitle("Sheep", for: .disabled)
                scrollView.addSubview(sheepButton)
                
                sheepButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)

                // 右下
                let hippopotamusButton = UIButton()
                hippopotamusButton.setBackgroundImage(hippopotamusImage, for: [])
                hippopotamusButton.layer.cornerRadius = 5
                hippopotamusButton.layer.masksToBounds  = true
                hippopotamusButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                hippopotamusButton.setTitle("Hippopotamus", for: .disabled)
                scrollView.addSubview(hippopotamusButton)
                
                hippopotamusButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            } else if i == 1 {
                
                let widthPage = width
                
                // 左上
                let gorillaButton = UIButton()
                gorillaButton.setBackgroundImage(gorillaImage, for: [])
                gorillaButton.layer.cornerRadius = 5
                gorillaButton.layer.masksToBounds  = true
                gorillaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                gorillaButton.setTitle("Gorilla", for: .disabled)
                scrollView.addSubview(gorillaButton)
                
                gorillaButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let elkButton = UIButton()
                elkButton.setBackgroundImage(elkImage, for: [])
                elkButton.layer.cornerRadius = 5
                elkButton.layer.masksToBounds  = true
                elkButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                elkButton.setTitle("Elk", for: .disabled)
                scrollView.addSubview(elkButton)
                
                elkButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let alligatorButton = UIButton()
                alligatorButton.setBackgroundImage(alligatorImage, for: [])
                alligatorButton.layer.cornerRadius = 5
                alligatorButton.layer.masksToBounds  = true
                alligatorButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                alligatorButton.setTitle("Alligator", for: .disabled)
                scrollView.addSubview(alligatorButton)
                
                alligatorButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右下
                let snakeButton = UIButton()
                snakeButton.setBackgroundImage(snakeImage, for: [])
                snakeButton.layer.cornerRadius = 5
                snakeButton.layer.masksToBounds  = true
                snakeButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                snakeButton.setTitle("Snake", for: .disabled)
                scrollView.addSubview(snakeButton)
                
                snakeButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            }  else if i == 2 {
                
                let widthPage = width * 2
                
                // 左上
                let pandaButton = UIButton()
                pandaButton.setBackgroundImage(pandaImage, for: [])
                pandaButton.layer.cornerRadius = 5
                pandaButton.layer.masksToBounds  = true
                pandaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                pandaButton.setTitle("Panda", for: .disabled)
                scrollView.addSubview(pandaButton)
                
                pandaButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let greatEgretButton = UIButton()
                greatEgretButton.setBackgroundImage(greatEgretImage, for: [])
                greatEgretButton.layer.cornerRadius = 5
                greatEgretButton.layer.masksToBounds  = true
                greatEgretButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                greatEgretButton.setTitle("GreatEgret", for: .disabled)
                scrollView.addSubview(greatEgretButton)
                
                greatEgretButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let koalaButton = UIButton()
                koalaButton.setBackgroundImage(koalaImage, for: [])
                koalaButton.layer.cornerRadius = 5
                koalaButton.layer.masksToBounds  = true
                koalaButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                koalaButton.setTitle("Koala", for: .disabled)
                scrollView.addSubview(koalaButton)
                
                koalaButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右下
                let kangarooButton = UIButton()
                kangarooButton.setBackgroundImage(kangarooImage, for: [])
                kangarooButton.layer.cornerRadius = 5
                kangarooButton.layer.masksToBounds  = true
                kangarooButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                kangarooButton.setTitle("Kangaroo", for: .disabled)
                scrollView.addSubview(kangarooButton)
                
                kangarooButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            }  else if i == 3 {
                
                let widthPage = width * 3
                
                // 左上
                let lionButton = UIButton()
                lionButton.setBackgroundImage(lionImage, for: [])
                lionButton.layer.cornerRadius = 5
                lionButton.layer.masksToBounds  = true
                lionButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                lionButton.setTitle("Lion", for: .disabled)
                scrollView.addSubview(lionButton)
                
                lionButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let antelopeButton = UIButton()
                antelopeButton.setBackgroundImage(antelopeImage, for: [])
                antelopeButton.layer.cornerRadius = 5
                antelopeButton.layer.masksToBounds  = true
                antelopeButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                antelopeButton.setTitle("Antelope", for: .disabled)
                scrollView.addSubview(antelopeButton)
                
                antelopeButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let cowButton = UIButton()
                cowButton.setBackgroundImage(cowImage, for: [])
                cowButton.layer.cornerRadius = 5
                cowButton.layer.masksToBounds  = true
                cowButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                cowButton.setTitle("Cow", for: .disabled)
                scrollView.addSubview(cowButton)
                
                cowButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右下
                let giraffeButton = UIButton()
                giraffeButton.setBackgroundImage(giraffeImage, for: [])
                giraffeButton.layer.cornerRadius = 5
                giraffeButton.layer.masksToBounds  = true
                giraffeButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                giraffeButton.setTitle("Giraffe", for: .disabled)
                scrollView.addSubview(giraffeButton)
                
                giraffeButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            }  else if i == 4 {
                
                let widthPage = width * 4
                
                // 左上
                let hedgehogButton = UIButton()
                hedgehogButton.setBackgroundImage(hedgehogImage, for: [])
                hedgehogButton.layer.cornerRadius = 5
                hedgehogButton.layer.masksToBounds  = true
                hedgehogButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                hedgehogButton.setTitle("Hedgehog", for: .disabled)
                scrollView.addSubview(hedgehogButton)
                
                hedgehogButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let rhinocerosButton = UIButton()
                rhinocerosButton.setBackgroundImage(rhinocerosImage, for: [])
                rhinocerosButton.layer.cornerRadius = 5
                rhinocerosButton.layer.masksToBounds  = true
                rhinocerosButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                rhinocerosButton.setTitle("Rhinoceros", for: .disabled)
                scrollView.addSubview(rhinocerosButton)
                
                rhinocerosButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let tRexButton = UIButton()
                tRexButton.setBackgroundImage(tRexImage, for: [])
                tRexButton.layer.cornerRadius = 5
                tRexButton.layer.masksToBounds  = true
                tRexButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                tRexButton.setTitle("TRex", for: .disabled)
                scrollView.addSubview(tRexButton)
                
                tRexButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右下
                let dogButton = UIButton()
                dogButton.setBackgroundImage(dogImage, for: [])
                dogButton.layer.cornerRadius = 5
                dogButton.layer.masksToBounds  = true
                dogButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                dogButton.setTitle("Dog", for: .disabled)
                scrollView.addSubview(dogButton)
                
                dogButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            }  else if i == 5 {
                
                let widthPage = width * 5
                
                // 左上
                let cottontailRabbitButton = UIButton()
                cottontailRabbitButton.setBackgroundImage(cottontailRabbitImage, for: [])
                cottontailRabbitButton.layer.cornerRadius = 5
                cottontailRabbitButton.layer.masksToBounds  = true
                cottontailRabbitButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                cottontailRabbitButton.setTitle("CottontailRabbit", for: .disabled)
                scrollView.addSubview(cottontailRabbitButton)
                
                cottontailRabbitButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右上
                let catButton = UIButton()
                catButton.setBackgroundImage(catImage, for: [])
                catButton.layer.cornerRadius = 5
                catButton.layer.masksToBounds  = true
                catButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                catButton.setTitle("Cat", for: .disabled)
                scrollView.addSubview(catButton)
                
                catButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 左下
                let batButton = UIButton()
                batButton.setBackgroundImage(batImage, for: [])
                batButton.layer.cornerRadius = 5
                batButton.layer.masksToBounds  = true
                batButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                batButton.setTitle("Bat", for: .disabled)
                scrollView.addSubview(batButton)
                
                batButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
                // 右下
                let elephantButton = UIButton()
                elephantButton.setBackgroundImage(elephantImage, for: [])
                elephantButton.layer.cornerRadius = 5
                elephantButton.layer.masksToBounds  = true
                elephantButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                elephantButton.setTitle("Elephant", for: .disabled)
                scrollView.addSubview(elephantButton)
                
                elephantButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                
            }else if i == 6 {
                
                let widthPage = width * 6
                
                // 左上
                let chimpanzeeButton = UIButton()
                chimpanzeeButton.setBackgroundImage(chimpanzeeImage, for: [])
                chimpanzeeButton.layer.cornerRadius = 5
                chimpanzeeButton.layer.masksToBounds  = true
                chimpanzeeButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                chimpanzeeButton.setTitle("Chimpanzee", for: .disabled)
                scrollView.addSubview(chimpanzeeButton)
                
                chimpanzeeButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
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
    
    // ボタンをプッシュした時の処理
    @objc func buttonEvent(sender: UIButton) {
        // AppDelegateのインスタンスを取得
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.path = "ZooModel/\(String(sender.title(for: .disabled)!)).scn"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //スクロール距離 = 1ページ(画面幅)
        if fmod(scrollView.contentOffset.x, scrollView.frame.width) == 0 {
            //ページの切り替え
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        }
    }

}
