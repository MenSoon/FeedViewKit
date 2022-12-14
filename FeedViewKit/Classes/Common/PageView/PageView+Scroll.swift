//
//  PageView+Scroll.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension FeedViewForPage {
    
    func startMoving(index:Int) {
        if let vc = self.dataSource.viewController {
            vc.startMoving(index: index)
        }
    }
    
    func endMoving(_ scrollView:UIScrollView) {
        if let vc = self.dataSource.viewController {
        
            vc.endMoving(scrollView)
            
            return
        }
        
        guard self.dataSource.isMoving else { return }
        
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        
        if (self.dataSource.toIndex > self.dataSource.selectedIndex) {
            if (offsetX >=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.commonLog("[翻页 - 向右] - 成功");
                
                self.dataSource.selectedIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.commonLog("[翻页 - 向右] - 失败，回弹");
            }
        } else {
            if (offsetX <=~ CGFloat(self.dataSource.toIndex) * contentWidth) {
                Utils.commonLog("[翻页 - 向左] - 成功");
                
                self.dataSource.selectedIndex = self.dataSource.toIndex;
            } else { //回弹
                Utils.commonLog("[翻页 - 向左] - 失败，回弹");
            }
        }
        
        self.dataSource.toIndex = -1;
        self.dataSource.isMoving = false;
    }
    
    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        self.dragPointX = scrollView.contentOffset.x
    }
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        guard scrollView.isDragging else { return }
        let offsetX = scrollView.contentOffset.x;
        let contentWidth = scrollView.bounds.size.width;
        if (offsetX < 0 || offsetX > CGFloat(self.dataSource.items.count - 1) * contentWidth) {
            return
        }
        
        if offsetX > self.dragPointX {
            //            self.dataSource.toIndex = self.dataSource.selectedIndex + 1
            self.dataSource.toIndex = max(Int(offsetX / contentWidth), self.dataSource.selectedIndex + 1)
        } else if offsetX < self.dragPointX {
            //            self.dataSource.toIndex = self.dataSource.selectedIndex - 1
            self.dataSource.toIndex = min(Int(offsetX / contentWidth), self.dataSource.selectedIndex - 1)
        } else {
            //            self.dataSource.toIndex = self.dataSource.selectedIndex
            self.dataSource.toIndex = Int(offsetX / contentWidth)
        }
        
        if (self.dataSource.toIndex > -1 && self.dataSource.toIndex < self.dataSource.items.count) {
            self.dataSource.isMoving = true
            self.dataSource.toIndexSignal.onNext(self.dataSource.toIndex)
        }
    }
    
    override public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if !decelerate {
            self.endMoving(scrollView)
        }
    }
    
    override public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        self.endMoving(scrollView)
    }
    
    override public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        self.endMoving(scrollView)
    }
}

