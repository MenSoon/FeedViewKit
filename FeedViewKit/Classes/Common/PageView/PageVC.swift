//
//  PageVC.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public extension PageVC {
    func show(at index:Int) {
        guard index > -1,
            index < self.viewControllers.count,
            self.viewControllers.count > 0,
            index != self.selectedIndex
            else { return }
        
        if !self.pageView.isMoving {
            if let fromVC = self.selectedViewController {
                fromVC.beginAppearanceTransition(false, animated: false)
                fromVC.endAppearanceTransition()
            }
            
            let toVC = self.viewControllers[index]
            if toVC.parent == nil {
                self.addChild(toVC)
                toVC.didMove(toParent: self)
            }
            toVC.beginAppearanceTransition(true, animated: false)
            toVC.endAppearanceTransition()
            self.selectedViewController = toVC
        }
        
        self.pageView.show(at: index)
    }
    
    @objc func removeAll() {
        for vc in self.viewControllers {
            vc.willMove(toParent: nil)
            vc.removeFromParent()
            vc.beginAppearanceTransition(false, animated: false)
            vc.endAppearanceTransition()
        }
        self.selectedViewController = nil
        self.viewControllers.removeAll()
        
        self.pageView.removeAll()
    }
    
    @objc func remove(at index:Int) {
        guard index > -1, index < self.viewControllers.count, self.viewControllers.count > 0 else { return }
        
        let removeVC = self.viewControllers[index]
        if let _ = removeVC.parent {
            removeVC.willMove(toParent: nil)
            removeVC.removeFromParent()
            removeVC.beginAppearanceTransition(false, animated: false)
            removeVC.endAppearanceTransition()
        }
        self.viewControllers.remove(at: index)
        
        self.pageView.remove(at: index)
    }
    
    @objc func insert(newElement: UIViewController, at: Int) {
        self.insert(contentsOf: [newElement], at: at)
    }
    
    @objc func insert(contentsOf: [UIViewController], at: Int) {
        guard at <= viewControllers.count, contentsOf.count > 0 else { return }
        
        self.viewControllers.insert(contentsOf: contentsOf, at: at)
        
        var views: [UIView] = []
        for vc in contentsOf {
            views.append(vc.view)
            for subView in vc.view.subviews {
                if let subView = subView as? FeedPageInnerFeedView {
                    subView.outerFeedPageView = self.viewController?.feedPageView
                    if subView.delayBindBlock != nil {
                        subView.delayBindBlock!()
                    }
                }
            }
        }
        self.pageView.insert(contentsOf: views, at: at)
    }
}

extension PageVC {
    override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    override open func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}

@objc open class PageVC:UIViewController {
    public var disposeBag = DisposeBag()
    
    @objc public var viewControllers:[UIViewController] = []
    @objc public var selectedViewController:UIViewController!
    
    public var selectedIndexObservable:Variable<Int> {
        get {
            return self.pageView.selectedIndexObservable
        }
    }
    
    @objc public var selectedIndex:Int {
        get {
            return self.pageView.selectedIndex
        }
        set {
            self.pageView.selectedIndex = newValue
        }
    }
    
    var isMoving:Bool {
        get {
            return self.pageView.isMoving
        }
        set {
            self.pageView.isMoving = newValue
        }
    }
    
    private var pgView = PageView()
    public var pageView:PageView {
        get {
            return self.pgView
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageView.viewController = self
        self.view.addSubview(self.pageView)
        self.pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    weak var viewController: FeedPageVC?
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension PageVC {
    func startMoving(index:Int) {}
    
    func endMoving(_ scrollView: UIScrollView) {
        guard self.pageView.isMoving else { return }
        
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        
        self.selectedViewController = self.viewControllers[self.pageView.selectedIndex];
        //处理 因快速切换导致的 self.pageView.toIndex 值为 0 或者索引越界 取值崩溃问题
        if self.pageView.toIndex < 0 || self.pageView.toIndex >= self.viewControllers.count{
            return
        }
        let toViewController = self.viewControllers[self.pageView.toIndex];
        
        if toViewController.parent == nil {
            self.addChild(toViewController)
            toViewController.didMove(toParent: self)
        }
        
        self.selectedViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        if (self.pageView.toIndex > self.pageView.selectedIndex) {
            if (offsetX >=~ CGFloat(self.pageView.toIndex) * contentWidth) {
                
                Utils.commonLog("[翻页 - 向右] - 成功");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                self.selectedViewController = toViewController
                
                self.pageView.selectedIndex = self.pageView.toIndex;
            } else { //回弹
                
                Utils.commonLog("[翻页 - 向右] - 失败，回弹");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                toViewController.beginAppearanceTransition(false, animated: true)
                self.selectedViewController.beginAppearanceTransition(true, animated: true)
                
                toViewController.endAppearanceTransition()
                self.selectedViewController.endAppearanceTransition()
            }
        } else {
            if (offsetX <=~ CGFloat(self.pageView.toIndex) * contentWidth) {
                
                Utils.commonLog("[翻页 - 向左] - 成功");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                self.selectedViewController = toViewController
                
                self.pageView.selectedIndex = self.pageView.toIndex;
            } else { //回弹
                
                Utils.commonLog("[翻页 - 向左] - 失败，回弹");
                
                self.selectedViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
                
                toViewController.beginAppearanceTransition(false, animated: true)
                self.selectedViewController.beginAppearanceTransition(true, animated: true)
                
                toViewController.endAppearanceTransition()
                self.selectedViewController.endAppearanceTransition()
            }
        }
        
        self.pageView.toIndex = -1;
        self.pageView.isMoving = false;
    }
}

