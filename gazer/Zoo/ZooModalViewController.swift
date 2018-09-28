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
    let width:CGFloat = UIScreen.main.bounds.size.width
    let height:CGFloat = UIScreen.main.bounds.size.height
    
    // ボタンの画像
    let zebraImage:UIImage = UIImage(named:"ZooImage/Zebra")!
    let unicornImage:UIImage = UIImage(named:"ZooImage/Unicorn")!
    let sheepImage:UIImage = UIImage(named: "ZooImage/Sheep")!
    let hippopotamusImage:UIImage = UIImage(named: "ZooImage/Hippopotamus")!
    let sheepImage:UIImage = UIImage(named: "ZooImage/Sheep")!

    
    // ボタン配置変数
    var prevButton:CGFloat = 20
    
    // ボタンの辺の長さ
    let buttonSide:CGFloat = (UIScreen.main.bounds.size.width * 12) / 30
    
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
                sheepButton.setBackgroundImage(unicornImage, for: [])
                sheepButton.layer.cornerRadius = 5
                sheepButton.layer.masksToBounds  = true
                sheepButton.frame = CGRect(x: (width / 30) * 2, y: (width / 30) * 6 + buttonSide,
                                             width: buttonSide, height: buttonSide)
                scrollView.addSubview(sheepButton)

                // 右下
                let hippopotamusButton = UIButton()
                hippopotamusButton.setBackgroundImage(zebraImage, for: [])
                hippopotamusButton.layer.cornerRadius = 5
                hippopotamusButton.layer.masksToBounds  = true
                hippopotamusButton.frame = CGRect(x: (width / 30) * 4 + buttonSide, y: (width / 30) * 6 + buttonSide,
                                           width: buttonSide, height: buttonSide)
                scrollView.addSubview(hippopotamusButton)
                
            } else if i == 1 {
                
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
