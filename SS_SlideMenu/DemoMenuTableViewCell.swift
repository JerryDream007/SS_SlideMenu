//
//  DemoMenuTableViewCell.swift
//  SS_SlideMenu
//
//  Created by 宋澎 on 2018/8/8.
//  Copyright © 2018年 宋澎. All rights reserved.
//

import UIKit

class DemoMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString:String?{
        didSet{
            self.titleLabel.text = titleString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
