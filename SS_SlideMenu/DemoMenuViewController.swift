//
//  DemoMenuViewController.swift
//  SS_SlideMenu
//
//  Created by 宋澎 on 2018/8/8.
//  Copyright © 2018年 宋澎. All rights reserved.
//

import UIKit

class DemoMenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var dataSource:[DemoMenuViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = DemoMenuDataSource().modelArray
    }
}

extension DemoMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoMenuTableViewCellID", for: indexPath) as? DemoMenuTableViewCell {
             let model = self.dataSource?[indexPath.row]
            cell.titleString = model?.title
            return cell
        }
        return UITableViewCell()
    }
    
    
}
