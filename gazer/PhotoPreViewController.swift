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
    /*
    @IBOutlet weak var aquaPreviewImage: UIImageView!
    @IBOutlet weak var aquaSaveButton: UIButton!
 */
    
    @IBAction func zooSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func zooCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    @IBAction func aquaSaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func aquaCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 */
    
    var screenImage:UIImage? = nil
    var addImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        switch addImage {
        case 1:
            zooPreviewImage.image = screenImage
            zooSaveButton.layer.cornerRadius = 20.0 // 角丸のサイズ
/*
        case 2:
            aquaPreviewImage.image = screenImage
            aquaSaveButton.layer.cornerRadius = 20.0 // 角丸のサイズ
*/
        default:
            print("Error")
        }
    }
    
}
