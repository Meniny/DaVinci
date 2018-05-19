//
//  ViewController.swift
//  iOS
//
//  Created by Meniny on 2018-01-20.
//  Copyright © 2018年 Meniny. All rights reserved.
//

import UIKit
import DaVinci

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = DaVinciImage.arrow(.right,
                                  square: 66,
                                  color: #colorLiteral(red: 0.05, green:0.49, blue:0.98, alpha:0.8).cgColor,
                                  background: UIColor.white.cgColor)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

