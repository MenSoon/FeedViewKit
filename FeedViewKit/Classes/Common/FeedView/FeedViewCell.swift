//
//  File.swift
//  CYZS
//
//  Created by Shon on 2017/8/24.
//  Copyright © 2017年 SPM. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

//import SnapKit
//import ObjectMapper

public protocol FeedViewCellProtocol {
    var viewModel: FeedViewCellViewModelProtocol? { get set }
    var disposeBag: DisposeBag { get set }
    
    func set()
    func bind()
    func layout()
    
}

open class FeedViewCell: UICollectionViewCell, FeedViewCellProtocol {
    public weak var parentFeedView:FeedView?
    
    public var disposeBag: DisposeBag = DisposeBag()
    public var onceDisposeBag: DisposeBag = DisposeBag()
    
    @objc public var viewModel: FeedViewCellViewModelProtocol? {
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
    
    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func set() {}
    
    open func bind() {}
    
    open func onceBind() {}
    
    open func layout() {}
    
    open class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        return .zero
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

