//
//  SS_SlideMenuViewController.swift
//  SS_SlideMenu
//
//  Created by 宋澎 on 2018/8/8.
//  Copyright © 2018年 宋澎. All rights reserved.
//

import UIKit

class SS_SlideMenuViewController: UIViewController {

    struct SlideMenuAnimationConfig {
        var duration:TimeInterval = 1.0
        var damping:CGFloat = 1.0
        var velocity:CGFloat = 0.5
        init() {
            
        }
        init(duration:TimeInterval,damping:CGFloat,velocity:CGFloat) {
            self.duration = duration
            self.damping = damping
            self.velocity = velocity
        }
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!    //背景图
    @IBOutlet weak var menuContainerView: UIView!           //菜单容器
    @IBOutlet weak var mainContainerView: UIView!           //主视图容器
    
    @IBOutlet weak var menuContainerViewWidth: NSLayoutConstraint!      //菜单容器的宽度
    @IBOutlet weak var menuContainerViewLeftSpace: NSLayoutConstraint!  //菜单容器的左边距
    @IBOutlet weak var mainContainerViewLeftSpace: NSLayoutConstraint!  //主容器的左边距
    
    var backgroundImageName:String?
    var menuController:UIViewController?    //菜单控制器
    var mainController:UIViewController?    //主控制器
    let mainTapView = UIView()              //主控制器上的点击视图
    
    
    var slideScale:CGFloat = 0.8                                                        //主控制器的缩放比例
    var slideDistance = CGFloat(3.0/4.0) * UIScreen.main.bounds.width           //菜单栏占比
    var slideAnimationConfig:SlideMenuAnimationConfig = SlideMenuAnimationConfig()   //动画配置
 
    init(menuController:UIViewController,mainController:UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.menuController = menuController
        self.mainController = mainController
    }
    
    convenience init(menuController:UIViewController,mainController:UIViewController,backgroundImageName:String){
        self.init(menuController: menuController, mainController: mainController)
        self.backgroundImageName = backgroundImageName
    }
    
    convenience init(menuController:UIViewController,mainController:UIViewController,backgroundImageName:String,slideScale:CGFloat){
        self.init(menuController: menuController, mainController: mainController, backgroundImageName: backgroundImageName)
        self.slideScale = slideScale
    }
    
    convenience init(menuController:UIViewController,mainController:UIViewController,backgroundImageName:String,slideScale:CGFloat,slideDistanceScale:CGFloat){
        self.init(menuController: menuController, mainController: mainController, backgroundImageName: backgroundImageName, slideScale: slideScale)
        self.slideDistance = slideDistanceScale * UIScreen.main.bounds.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.backgroundImageName != nil {
            self.backgroundImageView.image = UIImage(named: self.backgroundImageName!)
        }
        self.setupContainerView()
        self.setupMainTapView()
        self.setupPanGesture()
    }
    
    //布局容器
    func setupContainerView() {
        if let menuView = self.menuController?.view {
            menuView.frame = self.menuContainerView.bounds
            self.addChildViewController(self.menuController!)
            self.menuContainerView.addSubview(menuView)
            self.menuController?.didMove(toParentViewController: self)
        }
        
        if let mainView = self.mainController?.view{
            mainView.frame = self.mainContainerView.bounds
            self.addChildViewController(self.mainController!)
            self.mainContainerView.addSubview(mainView)
            self.mainController?.didMove(toParentViewController: self)
        }
    }
    
    //给主容器增加点击手势
    func setupMainTapView(){
        self.mainTapView.frame = self.mainContainerView.bounds
        self.mainContainerView.addSubview(self.mainTapView)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleMainTapGesture(tapGesure:)))
        self.mainTapView.addGestureRecognizer(tapGesture)
        self.mainTapView.isHidden = true
    }
    
    //设置打开的滑动手势
    func setupPanGesture(){
        let openMenuPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleOpenPanGesture(panGesture:)))
        self.mainController?.view.addGestureRecognizer(openMenuPanGesture)
        
        let closeMenuPanGesure = UIPanGestureRecognizer.init(target: self, action: #selector(handleClosePanGesture(panGesture:)))
        self.menuController?.view.addGestureRecognizer(closeMenuPanGesure)
    }
    
    //处理主容器的点击手势
    @objc func handleMainTapGesture(tapGesure:UITapGestureRecognizer){
        self.closeMenu()
    }
    
    //处理滑动打开手势
    @objc func handleOpenPanGesture(panGesture:UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: panGesture.view)
        let velocity = panGesture.velocity(in: panGesture.view)
        
        switch panGesture.state {
        case .began:
            print("打开手势状态:开始")
        case .changed:
            print("打开手势状态:改变")
            if translation.x > 0{
                var scale = translation.x / (self.mainController?.view.frame.width)!
                scale = min(max(0, scale),1)
                self.openMenuWithScale(scale: scale)
            }
        case .ended:
            print("打开手势状态:结束")
            if translation.x > 0{
                if velocity.x > 200{
                    self.openMenuWithScale(scale: 1.0)
                    break
                }
                let scale = translation.x / (self.mainController?.view.frame.width)!
                if scale > 0.5{
                    self.openMenuWithScale(scale: 1.0)
                }else{
                    self.openMenuWithScale(scale: 0.0)
                }
            }else{
                self.openMenuWithScale(scale: 0.0)
            }
        default:
            print("打开手势状态:取消 或 失败 或 未知")
            self.openMenuWithScale(scale: 0.0)
        }
    }
    
    //处理滑动关闭手势
    @objc func handleClosePanGesture(panGesture:UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: panGesture.view)
        let velocity = panGesture.velocity(in: panGesture.view)
        
        switch panGesture.state {
        case .began:
            print("关闭手势状态:开始")
        case .changed:
            print("关闭手势状态:改变")
            if translation.x < 0{
                var scale = fabs(translation.x) / (self.menuController?.view.frame.width)!
                scale = min(max(0, scale),1)
                self.closeMenuWithScale(scale: scale)
            }
        case .ended:
            print("关闭手势状态:结束")
            if translation.x < 0{
                if fabs(velocity.x) > 200{
                    self.closeMenuWithScale(scale: 1.0)
                    break
                }
                let scale = fabs(translation.x) / (self.menuController?.view.frame.width)!
                if scale > 0.5{
                    self.closeMenuWithScale(scale: 1.0)
                }else{
                    self.closeMenuWithScale(scale: 0.0)
                }
            }else{
                self.closeMenuWithScale(scale: 0.0)
            }
        default:
            print("关闭手势状态:取消 或 失败 或 未知")
            self.closeMenuWithScale(scale: 0.0)
        }
    }
    
    //打开菜单
    func openMenu(){
        self.mainTapView.isHidden = false
        UIView.animate(withDuration: self.slideAnimationConfig.duration, delay: 0.0, usingSpringWithDamping: self.slideAnimationConfig.damping, initialSpringVelocity: self.slideAnimationConfig.velocity, options: .curveEaseIn, animations: {
            self.menuContainerViewLeftSpace.constant = 0
            self.menuContainerViewWidth.constant = self.slideDistance + self.mainContainerView.frame.width * CGFloat( (1-self.slideScale)/2 )
            self.mainContainerView.transform = CGAffineTransform.init(scaleX: self.slideScale, y: self.slideScale)
            self.mainContainerViewLeftSpace.constant = self.slideDistance
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    //百分比打开菜单
    func openMenuWithScale(scale:CGFloat){
        if scale == 1.0 {
            self.mainTapView.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.menuContainerViewLeftSpace.constant = -(self.slideDistance * (1 - scale))
            self.menuContainerViewWidth.constant = (self.slideDistance + self.mainContainerView.frame.width * CGFloat((1 - self.slideScale) / 2)) * scale
            let transformScaleX = self.slideScale + (1 - self.slideScale) * (1 - scale)
            self.mainContainerView.transform = CGAffineTransform.init(scaleX: transformScaleX, y: transformScaleX)
            self.mainContainerViewLeftSpace.constant = self.slideDistance * scale
            self.view.layoutIfNeeded()
        }){ (_) in
            
        }
    }
    
    //关闭菜单
    func closeMenu(){
        self.mainTapView.isHidden = true
        UIView.animate(withDuration: self.slideAnimationConfig.duration, delay: 0.0, usingSpringWithDamping: self.slideAnimationConfig.damping, initialSpringVelocity: self.slideAnimationConfig.velocity, options: .curveEaseOut, animations: {
            self.menuContainerViewLeftSpace.constant = -self.slideDistance
            self.mainContainerViewLeftSpace.constant = 0
            self.mainContainerView.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    //百分比关闭菜单
    func closeMenuWithScale(scale:CGFloat){
        if scale == 1.0 {
            self.mainTapView.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.menuContainerViewLeftSpace.constant = -(self.slideDistance * scale)
            self.mainContainerViewLeftSpace.constant = self.slideDistance * (1 - scale)
            let transformScaleX = self.slideScale + (1 - self.slideScale) * scale
            self.mainContainerView.transform = CGAffineTransform.init(scaleX: transformScaleX, y: transformScaleX)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
}
