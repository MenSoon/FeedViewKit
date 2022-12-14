//
//  PageHeaderView.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

@objc open class PageTabItemView:UIView {
    public var disposeBag = DisposeBag()
    
    open var isSelected:Bool = false {
        didSet {
            //TODO:
        }
    }
    
    open func tabWidth() -> CGFloat {
        return 0
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

@objc open class PageTabView:UIView {
    @objc public var feedView:FeedViewForPageTab!
    
    @objc public var lineScrollView:UIScrollView!
    @objc public var lineView:UIView!
    
    @objc public var lineHeight:CGFloat = 2
    @objc public var lineBottomOffset:CGFloat = 0
    @objc public var lineSpacing:CGFloat = 0
    @objc public var lineMinWidth:CGFloat = 10
    
    @objc public var lineWidth:CGFloat = 0
    
    public var disposeBag = DisposeBag()
    
    @objc public var items:[PageTabItemView] = []
    
    @objc public var selectedChangeBlock: (Int) -> () = { _ in }
    
    public var selectedIndexObservable:Variable<Int> = Variable(-1)
    
    @objc public var selectedIndex:Int = -1 {
        didSet {
            if oldValue != selectedIndex {
                var width:CGFloat = 0
                var index = 0
                var selectedTab:PageTabItemView!
                var selectedTabLeft:CGFloat = 0
                
                for tab in self.items {
                    if index == self.selectedIndex {
                        selectedTabLeft = width
                        selectedTab = tab
                    }
                    tab.isSelected = index == self.selectedIndex
                    width += tab.tabWidth()
                    index += 1
                }
                
                if oldValue == selectedIndex {
                    Utils.commonLog("Tab - 选中索引未发生改变，这里直接返回，不执行任何动作：\(selectedIndex)")
                    return;
                }
                Utils.commonLog("Tab - 改变选中索引：\(selectedIndex)")
                
                self.lineView.isHidden = self.selectedIndex < 0
                
                guard self.selectedIndex > -1 else { return }
                
                let selectedTabCenterX = selectedTabLeft + selectedTab.tabWidth() / 2
                
                var contentOffsetX:CGFloat = -self.feedView.collectionView.contentInset.left
                if self.feedView.collectionView.contentSize.width > self.bounds.size.width {
                    contentOffsetX = min(max(selectedTabCenterX - self.bounds.size.width / 2, -self.feedView.collectionView.contentInset.left), self.feedView.collectionView.contentSize.width - self.bounds.size.width + self.feedView.collectionView.contentInset.right)
                }
                
                self.feedView.collectionView.setContentOffset(.init(x: contentOffsetX, y: 0), animated: true)
                self.lineScrollView.contentSize = .init(width: self.feedView.collectionView.contentSize.width, height: self.lineHeight)
                
                self.lineScrollView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.lineHeight)
                }
                
                self.layoutIfNeeded() //因自动布局的延后性，可能这个时候某些视图的bounds还是.zero，影响计算，所以这里做一下强制布局，提前完成布局工作，即可拿到正确的尺寸
                UIView.animate(withDuration: 0.3, animations: {
                    self.lineView.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(selectedTabCenterX)
                        make.top.equalTo(0)
                        make.height.equalTo(self.lineHeight)
                        if self.lineWidth > 0 {
                            make.width.equalTo(self.lineWidth)
                        } else {
                            make.width.equalTo(max(self.lineMinWidth, selectedTab.tabWidth() - self.lineSpacing * 2))
                        }
                    }
                    self.layoutIfNeeded()
                })
                
                self.selectedIndexObservable.value = self.selectedIndex
                self.selectedChangeBlock(self.selectedIndex)
            }
        }
    }
    
    @objc public var isMoving:Bool = false
    
    public weak var viewController:PageVC?
    
    @objc public func show(at index:Int) {
        guard index < items.count else { return }
        self.selectedIndex = index
    }
    
    @objc public func remove(at index: Int) {
        guard index < items.count && self.feedView.sectionViewModels.count > 0 else { return }
        
        self.items[index].removeFromSuperview()
        self.items.remove(at: index)
        
        self.feedView.remove(section: 0, at: index, reload:true)
    }
    
    @objc public func removeAll() {
        self.feedView.remove(section: 0, reload:true)
        for view in self.items {
            view.removeFromSuperview()
        }
        self.items.removeAll()
        self.selectedIndex = -1
    }
    
    @objc public func insert(newElement: PageTabItemView, at: Int) {
        self.insert(contentsOf: [newElement], at: at)
    }
    
    @objc func tap(tap: UITapGestureRecognizer) {
        if let tView = tap.view as? PageTabItemView,
            let index = self.items.firstIndex(of: tView) {
            self.selectedIndex = index
        }
    }
    
    @objc public func insert(contentsOf: [PageTabItemView], at: Int) {
        guard at <= items.count else { return }
        
        self.items.insert(contentsOf: contentsOf, at: at)
        
        var cellVMS:[FeedViewCellViewModel] = []
        for view in contentsOf {
            let cellVM = FeedViewCellViewModel.init()
            cellVMS.append(cellVM)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap(tap:)))
            view.addGestureRecognizer(tap)
        }
        self.feedView.insert(contentsOf: cellVMS, at: at, section: 0, reload:true)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.feedView = FeedViewForPageTab.init(frame: .zero, layoutType: .flow, scrollDirection: .horizontal)
        self.feedView.dataSource = self
        self.feedView.collectionView.isPagingEnabled = false
        self.feedView.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.lineScrollView = UIScrollView()
        self.lineScrollView.isUserInteractionEnabled = false
        self.addSubview(self.lineScrollView)
        self.lineScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-self.lineBottomOffset)
            make.height.equalTo(self.lineHeight)
        }
        
        self.lineView = UIView()
        self.lineScrollView.addSubview(self.lineView)
    }
    
    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}

extension PageTabView:FeedViewForPageTabDataSource {
    public func feedView(viewForCellAt index: Int) -> UIView {
        return self.items[index]
    }
}

private let FeedPageCellViewTag = 1000

public protocol FeedViewForPageTabDataSource:class {
    func feedView(viewForCellAt index: Int) -> UIView
}

open class FeedViewForPageTab:FeedView {
    public weak var dataSource:PageTabView!
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            self.registerDict[reuseIdentifier] = reuseIdentifier
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        
        if let view = cell.contentView.viewWithTag(FeedPageCellViewTag) {
            let tView = self.dataSource.feedView(viewForCellAt: indexPath.row)
            guard view != tView else { return cell }
            
            view.removeFromSuperview()
            
            tView.tag = FeedPageCellViewTag
            cell.contentView.addSubview(tView)
            tView.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
        } else {
            let view = self.dataSource.feedView(viewForCellAt: indexPath.row)
            
            view.tag = FeedPageCellViewTag
            cell.contentView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
        }
        self.dataSource.lineScrollView.contentSize = .init(width: collectionView.contentSize.width, height: self.dataSource.lineHeight)
        return cell
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.dataSource.lineScrollView.contentSize = .init(width: collectionView.contentSize.width, height: self.dataSource.lineHeight)
        let view = self.dataSource.items[indexPath.row]
        return CGSize.init(width: view.tabWidth(), height: self.bounds.size.height)
    }
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        self.dataSource.lineScrollView.contentSize = .init(width: scrollView.contentSize.width, height: self.dataSource.lineHeight)
        self.dataSource.lineScrollView.contentOffset = scrollView.contentOffset
        self.dataSource.lineScrollView.contentInset = UIEdgeInsets.init(top: 0, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
    }
}
