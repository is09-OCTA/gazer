//
//  ZooPhotoPreViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/11/15.
//  Copyright © 2018 OCTA. All rights reserved.
//

import UIKit

class ZooPhotoPreViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(screenImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var screenImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       previewImage.image = screenImage
        
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        saveButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        

    }
    
}
