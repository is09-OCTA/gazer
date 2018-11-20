//
//  PhotoPreViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/11/15.
//  Copyright © 2018 OCTA. All rights reserved.
//

import UIKit

class PhotoPreViewController: UIViewController {
    // 動物園
    @IBOutlet weak var zooSaveButton: UIButton!
    @IBOutlet weak var zooPreviewImage: UIImageView!
    
    // 水族館
    @IBOutlet weak var aquaPreviewImage: UIImageView!
    @IBOutlet weak var aquaSaveButton: UIButton!
    
    //星
    @IBOutlet weak var starPreviewImage: UIImageView!
    @IBOutlet weak var starSaveButton: UIButton!
    
    // プロマ
/*
    @IBOutlet weak var mappingPreviewImage: UIImageView!
    @IBOutlet weak var mappingSaveButton: UIButton!
*/
    
    // 動物園
    @IBAction func zooSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func zooCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 水族館
    @IBAction func aquaSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func aquaCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 星
    @IBAction func starSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func starCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //プロマ
/*
     @IBAction func mappingSaveButton(_ sender: UIButton) {
     UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
     self.dismiss(animated: true, completion: nil)
     }
     @IBAction func mappingCancelButton(_ sender: UIButton) {
     self.dismiss(animated: true, completion: nil)
     }
*/
    var screenImage:UIImage? = nil
    var addImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        switch addImage {
        case 1:// 動物園
            zooPreviewImage.image = screenImage
            zooSaveButton.layer.cornerRadius = 20.0 // 保存ボタン角丸
            
        case 2:// 水族館
            aquaPreviewImage.image = screenImage
            aquaSaveButton.layer.cornerRadius = 20.0 // 保存ボタ角丸
            
        case 3:// 星
            starPreviewImage.image = screenImage
            starSaveButton.layer.cornerRadius = 20.0 // 保存ボタン角丸角丸
/*
        case 4:// プロマ
             mappingPreviewImage.image = screenImage
             mappingSaveButton.layer.cornerRadius = 20.0 // 保存ボタン角丸
*/
        default:// エラー
            print("PhotoPreviewControllerError")
        }
    }
    
}
