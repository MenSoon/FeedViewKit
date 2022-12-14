//
//  FeedViewCellViewModel.swift
//  CYZS
//
//  Created by Shon on 2017/9/4.
//  Copyright © 2017年 SPM. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

@objc public protocol FeedViewCellViewModelProtocol {
    //context用来传递一些上下文信息，可以用于区分返回不同的视图类型
    func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type
}

@objc open class FeedViewCellViewModel:NSObject, FeedViewCellViewModelProtocol {
    @objc public var staticsContext: [String: Any] = [:]
    @objc public var staticsEvent: String = ""
    
    public override init() {}
    
    @objc open func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewCell.self
    }
    
    @objc open func isRepeat(other:FeedViewCellViewModel) -> Bool {
        return false
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
