//
//  PhotoPreViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/11/15.
//  Copyright © 2018 OCTA. All rights reserved.
//

import UIKit

class PhotoPreViewController: UIViewController {

    @IBOutlet weak var zooSaveButton: UIButton!
    @IBOutlet weak var zooPreviewImage: UIImageView!
    @IBOutlet weak var aquaPreviewImage: UIImageView!
    @IBOutlet weak var aquaSaveButton: UIButton!
    
    @IBAction func zooSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func zooCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    @IBAction func aquaSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func aquaCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var screenImage:UIImage? = nil
    var addImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        // スクリーンの横縦幅取得
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        // 保存ボタン生成
        let saveButton = UIButton()
        saveButton.frame = CGRect(x:screenWidth/4, y:screenHeight/2,
                                  width:screenWidth/2, height:50)
        saveButton.setTitle("保存", for:UIControlState.normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.titleLabel?.font =  UIFont.systemFont(ofSize: 22)
        saveButton.backgroundColor = UIColor.init(
            red:0.9, green: 0.9, blue: 0.9, alpha: 1)
        
*/
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        switch addImage {
        case 1:
            zooPreviewImage.image = screenImage
            zooSaveButton.layer.cornerRadius = 20.0 // 角丸のサイズ
        case 2:
            aquaPreviewImage.image = screenImage
            aquaSaveButton.layer.cornerRadius = 20.0 // 角丸のサイズ

        default:
            print("error")
        }
        //aquaPreviewImage.image = screenImage
        // aquaSaveButton.layer.cornerRadius = 20.0 // 角丸のサイズ
    }
    
}
