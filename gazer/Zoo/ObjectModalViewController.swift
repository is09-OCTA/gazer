    //
    //  ObjectModalViewController.swift
    //  gazer
    //
    //  Created by 佐藤玲 on 2018/11/01.
    //  Copyright © 2018 OCTA. All rights reserved.
    //
    
    import UIKit
    
    class ObjectModalViewController: UIViewController ,UIScrollViewDelegate{
        
        private var pageControl: UIPageControl!
        private var scrollView: UIScrollView!
        
        // 画面の横幅、縦幅
        var width:CGFloat = UIScreen.main.bounds.size.width
        let height:CGFloat = UIScreen.main.bounds.size.height
        
        let treeAImage:UIImage = UIImage(named:"ObjectImage/treeA")!
        let treeBImage:UIImage = UIImage(named:"ObjectImage/treeB")!
        let treeCImage:UIImage = UIImage(named:"ObjectImage/treeC")!
        let treeDImage:UIImage = UIImage(named:"ObjectImage/treeD")!
        let rockAImage:UIImage = UIImage(named:"ObjectImage/rockA")!
        let rockBImage:UIImage = UIImage(named:"ObjectImage/rockB")!
        let grassImage:UIImage = UIImage(named:"ObjectImage/grass")!
        let lakeImage:UIImage = UIImage(named:"ObjectImage/lake")!
        
        
        var prevButton:CGFloat = 20
        
        // ボタンの辺の長さ
        let buttonSide:CGFloat = (UIScreen.main.bounds.size.width * 12) / 30
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let page = 2
            
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
                    let treeAButton = UIButton()
                    treeAButton.setBackgroundImage(treeAImage, for: [])
                    treeAButton.layer.cornerRadius = 5
                    treeAButton.layer.masksToBounds  = true
                    treeAButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                    treeAButton.setTitle("treeA", for: .disabled)
                    scrollView.addSubview(treeAButton)
                    
                    treeAButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 右上
                    let treeBButton = UIButton()
                    treeBButton.setBackgroundImage(treeBImage, for: [])
                    treeBButton.layer.cornerRadius = 5
                    treeBButton.layer.masksToBounds  = true
                    treeBButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                    treeBButton.setTitle("treeB", for: .disabled)
                    scrollView.addSubview(treeBButton)
                    
                    treeBButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 左下
                    let treeCButton = UIButton()
                    treeCButton.setBackgroundImage(treeCImage, for: [])
                    treeCButton.layer.cornerRadius = 5
                    treeCButton.layer.masksToBounds  = true
                    treeCButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                    treeCButton.setTitle("treeC", for: .disabled)
                    scrollView.addSubview(treeCButton)
                    
                    treeCButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 右下
                    let treeDButton = UIButton()
                    treeDButton.setBackgroundImage(treeDImage, for: [])
                    treeDButton.layer.cornerRadius = 5
                    treeDButton.layer.masksToBounds  = true
                    treeDButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                    treeDButton.setTitle("treeD", for: .disabled)
                    scrollView.addSubview(treeDButton)
                    
                    treeDButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                } else if i == 1 {
                    
                    let widthPage = width
                    
                    // 左上
                    let rockAButton = UIButton()
                    rockAButton.setBackgroundImage(rockAImage, for: [])
                    rockAButton.layer.cornerRadius = 5
                    rockAButton.layer.masksToBounds  = true
                    rockAButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                    rockAButton.setTitle("rockA", for: .disabled)
                    scrollView.addSubview(rockAButton)
                    
                    rockAButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 右上
                    let rockBButton = UIButton()
                    rockBButton.setBackgroundImage(rockBImage, for: [])
                    rockBButton.layer.cornerRadius = 5
                    rockBButton.layer.masksToBounds  = true
                    rockBButton.frame = CGRect(x: ((width / 30) * 4  + buttonSide) + widthPage, y: (width / 30) * 4, width: buttonSide, height: buttonSide)
                    rockBButton.setTitle("rockB", for: .disabled)
                    scrollView.addSubview(rockBButton)
                    
                    rockBButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 左下
                    let lakeButton = UIButton()
                    lakeButton.setBackgroundImage(lakeImage, for: [])
                    lakeButton.layer.cornerRadius = 5
                    lakeButton.layer.masksToBounds  = true
                    lakeButton.frame = CGRect(x: ((width / 30) * 2) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                    lakeButton.setTitle("lake", for: .disabled)
                    scrollView.addSubview(lakeButton)
                    
                    lakeButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
                    // 右下
                    let grassButton = UIButton()
                    grassButton.setBackgroundImage(grassImage, for: [])
                    grassButton.layer.cornerRadius = 5
                    grassButton.layer.masksToBounds  = true
                    grassButton.frame = CGRect(x: ((width / 30) * 4 + buttonSide) + widthPage, y: (width / 30) * 6 + buttonSide, width: buttonSide, height: buttonSide)
                    grassButton.setTitle("grass", for: .disabled)
                    scrollView.addSubview(grassButton)
                    
                    grassButton.addTarget(self, action: #selector(ZooModalViewController.buttonEvent(sender: )), for: .touchUpInside)
                    
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
            appDelegate.path = "ObjectModel/\(String(sender.title(for: .disabled)!)).scn"
            self.dismiss(animated: true, completion: nil)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            //スクロール距離 = 1ページ(画面幅)
            if fmod(scrollView.contentOffset.x, scrollView.frame.width) == 0 {
                //ページの切り替え
                pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
            }
        }
    }
