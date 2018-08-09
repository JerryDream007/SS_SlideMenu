//
//  DemoMenuDataSource.swift
//  SS_SlideMenu
//
//  Created by 宋澎 on 2018/8/8.
//  Copyright © 2018年 宋澎. All rights reserved.
//

import Foundation

struct DemoMenuDataSource{
    private let titles = ["消息中心","皮肤中心","会员中心","流量包月","定时关闭","蝰蛇音效","音乐工具","个性彩铃","私人云盘"]
    var modelArray:[DemoMenuViewModel]?
    init() {
        self.modelArray = titles.map({ (title) -> DemoMenuViewModel in
            return DemoMenuViewModel.init(title: title)
        })
    }
}
