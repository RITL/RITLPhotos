//
//  NaviationCategory.swift
//  YSinaNavigationBarDemo
//
//  Created by YueWen on 16/3/10.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit

// MARK: ***********动态设置Navigation的透明度
var key:String = "CoverView"

extension UINavigationBar
{
    
    private var coverView:UIView?{
        
        set{
            //runtime添加动态关联的属性
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            //runtime读取动态关联的属性
            return objc_getAssociatedObject(self, &key) as? UIView
        }
    }
    
    
    
    /**
     *  设置 背景色
     */
    @available(iOS 8.0,*)
    func setViewColor(color:UIColor)
    {
        //如果覆盖图层为nil
        if(self.coverView == nil)
        {
            self.coverView = createBackGroudView()
            //将图层添加到导航Bar的底层
            self.insertSubview(self.coverView!, atIndex: 0)

        }
        self.coverView?.backgroundColor = color
    }
    
    
    
    /**
     *  设置透明度
     */
    @available (iOS 8.0, *)
    func setViewAlpha(alpha:CGFloat)
    {
        guard self.coverView != nil else
        {
            return
        }
        
        self.coverView!.backgroundColor = self.coverView!.backgroundColor!.colorWithAlphaComponent(alpha)
    }

    
    
    /**
     *  清除图层,视图消失时需要调用该方法，不然会影响其他页面的效果
     */
    @available (iOS 8.0, *)
    func relieveCover()
    {
        self.setBackgroundImage(nil, forBarMetrics: .Default)
        coverView?.removeFromSuperview()
        coverView = nil
    }
    
    
    // MARK: ***********private Function
    /// 创建背景视图
    @available (iOS 8.0, *)
    private func createBackGroudView() -> UIView
    {
        //设置背景图片及度量
        self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //去除自定义背景图后形成的下端黑色横线
        self.shadowImage = UIImage()
        //设置图层的frame
        let view = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: CGRectGetHeight(self.frame) + 20))
        view.userInteractionEnabled = false//人机不交互
        view.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]//自适应宽度和高度
        
        return view;
    }
}