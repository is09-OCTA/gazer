//
//  ViewController.swift
//  gazer
//
//  Created by 佐藤玲 on 2018/05/18.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBAction func goStarButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goStar", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
