//
//  DemoMainViewController.swift
//  SS_SlideMenu
//
//  Created by 宋澎 on 2018/8/8.
//  Copyright © 2018年 宋澎. All rights reserved.
//

import UIKit

class DemoMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickOpenMenuButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.slideMenuVC?.openMenu()
    }
    
}
