//
//  FeedViewCellHeader.swift
//  CYZS
//
//  Created by Shon on 2017/9/5.
//  Copyright © 2017年 SPM. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

public protocol FeedViewSectionHeaderOrFooterProtocol {
    var viewModel: FeedViewSectionHeaderOrFooterViewModel? { get set }
    var disposeBag: DisposeBag { get set }
    
    func set()
    func bind()
    func layout()
}

@objc open class FeedViewSectionHeaderOrFooter:UICollectionReusableView, FeedViewSectionHeaderOrFooterProtocol {

    public weak var parentFeedView:FeedView?
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var viewModel: FeedViewSectionHeaderOrFooterViewModel? {
        didSet {
            guard self.viewModel != nil else { return }
            self.set()
            self.bind()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.onceBind()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func set() {}
    open func bind() {}
    open func onceBind() {}
    open func layout() {}
    
    open class func sizeThatFits(_ viewModel:FeedViewSectionHeaderOrFooterViewModel?, size: CGSize = .zero) -> CGSize {
        return .zero
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
