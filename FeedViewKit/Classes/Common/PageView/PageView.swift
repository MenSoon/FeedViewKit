//
//  PageView.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

open class PageView:UIView {
    public var feedView:FeedViewForPage!
    
    public var items:[UIView] = []
    
    var toIndex:Int = -1
    
    var toIndexSignal = PublishSubject<Int>()
    
    private var _innerSelectedIndexObservable:Variable<Int> = Variable(-1)
    public var selectedIndexObservable:Variable<Int> {
        get {
            return _innerSelectedIndexObservable
        }
    }
    
    var selectedIndex:Int = -1 {
        didSet {
            
            if oldValue == selectedIndex {
                Utils.commonLog("Page - 选中索引未发生改变，这里直接返回，不执行任何动作：\(selectedIndex)")
                return;
            }
            
            Utils.commonLog("Page - 改变选中索引：\(selectedIndex)")
            
            self.layoutIfNeeded() //因自动布局的延后性，可能这个时候某些视图的bounds还是.zero，影响计算，所以这里做一下强制布局，提前完成布局工作，即可拿到正确的尺寸
            
            if #available(iOS 9, *) {
                self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
                    self.feedView.collectionView.setContentOffset(CGPoint.init(x: CGFloat(self.selectedIndex) * self.feedView.collectionView.bounds.size.width, y: 0), animated: false)
                })
            }
            
            self.selectedIndexObservable.value = self.selectedIndex
        }
    }
    
    public var isMoving:Bool = false
    
    public weak var viewController:PageVC?
    
    public func show(at index:Int) {
        guard index < items.count else { return }
        
        self.selectedIndex = index
    }
    
    public func remove(at index: Int) {
        guard index > -1, index < items.count, self.feedView.sectionViewModels.count > 0 else { return }
        
        self.items[index].removeFromSuperview()
        self.items.remove(at: index)
        
        self.feedView.remove(section: 0, at: index, reload:true)
    }
    
    public func removeAll() {
        self.feedView.remove(section: 0, reload:true)
        for view in self.items {
            view.removeFromSuperview()
        }
        self.items.removeAll()
        self.selectedIndex = -1
    }
    
    public func insert(newElement: UIView, at: Int) {
        self.insert(contentsOf: [newElement], at: at)
    }
    
    public func insert(contentsOf: [UIView], at: Int) {
        guard at <= items.count else { return }
        
        self.items.insert(contentsOf: contentsOf, at: at)
        
        var cellVMS:[FeedViewCellViewModel] = []
        for _ in contentsOf {
            let cellVM = FeedViewCellViewModel.init()
            cellVMS.append(cellVM)
        }
        self.feedView.insert(contentsOf: cellVMS, at: at, section: 0, reload:true)
    }
    
    override public  init(frame: CGRect) {
        super.init(frame: frame)
        
        self.feedView = FeedViewForPage.init(frame: .zero, layoutType: .flow, scrollDirection: .horizontal)
        self.feedView.dataSource = self
        self.feedView.collectionView.simultaneously = false
        self.feedView.collectionView.isPagingEnabled = true
        self.feedView.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension PageView:FeedViewForPageDataSource {
    public func feedView(viewForCellAt index: Int) -> UIView {
        return self.items[index]
    }
}

private let FeedPageCellViewTag = 1000

public protocol FeedViewForPageDataSource:class {
    func feedView(viewForCellAt index: Int) -> UIView
}

public class FeedViewForPage:FeedView {
    private var dsDisposeBag = DisposeBag()
    
    var dragPointX:CGFloat = 0
    
    weak var dataSource:PageView! {
        didSet {
            dsDisposeBag = DisposeBag()
            self.dataSource.toIndexSignal.distinctUntilChanged().bind { [weak self] (toIndex) in
                guard let sSelf = self else { return }
                if (toIndex > -1 && toIndex < sSelf.dataSource.items.count) {
                    Utils.commonLog("翻页 toIndex: \(toIndex)")
                    sSelf.startMoving(index: toIndex)
                }
            }.disposed(by: self.dsDisposeBag)
        }
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            self.registerDict[reuseIdentifier] = reuseIdentifier
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        
        let nextView = self.dataSource.feedView(viewForCellAt: indexPath.row)
        
        if let preView = cell.contentView.viewWithTag(FeedPageCellViewTag) {
            if preView == nextView {
                return cell
            } else {
                preView.removeFromSuperview()
            }
        }
        
        nextView.tag = FeedPageCellViewTag
        cell.contentView.addSubview(nextView)
        nextView.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView)
        }
        
        return cell
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
}
