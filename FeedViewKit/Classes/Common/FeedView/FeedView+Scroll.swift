//
//  FeedView+Scroll.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/21.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension FeedView {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didScrollSignal.onNext(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.didEndDraggingSignal.onNext((scrollView, decelerate))
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.didEndDeceleratingSignal.onNext(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.didEndScrollingAnimation.onNext(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.willBeginDragging.onNext(scrollView)
    }
}

