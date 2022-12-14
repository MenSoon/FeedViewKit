//
//  SYDCollectionView+Refresh.swift
//  CYZS
//
//  Created by Shon on 2017/8/24.
//  Copyright © 2017年 SPM. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

extension FeedView {
    private struct AssociatedKeys {
        static var FeedPageKey = "leo.feedview.page"
        static var FeedPageSizeKey = "leo.feedview.pageSize"
        static var FeedHasMoreKey = "leo.feedview.hasMore"
        static var FeedIsLoadingKey = "leo.feedview.isLoading"
        static var FeedShowHeaderKey = "leo.feedview.showHeader"
        static var FeedShowFooterKey = "leo.feedview.showFooter"
    }
    
    var showHeader: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedShowHeaderKey) {
                return value as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedShowHeaderKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
    
    var showFooter: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedShowFooterKey) {
                return value as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedShowFooterKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
    
    public var hasMore: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedHasMoreKey) {
                return value as! Bool
            }
            return true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedHasMoreKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
    
    public var isLoading: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedIsLoadingKey) {
                return value as! Bool
            }
            return true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedIsLoadingKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
        //        get {
        //            if self.showHeader && self.showFooter {
        //                return self.collectionView.leo_header.isRefreshing() || self.collectionView.leo_footer.isRefreshing()
        //            } else if self.showHeader {
        //                return self.collectionView.leo_header.isRefreshing()
        //            } else if self.showFooter {
        //                return self.collectionView.leo_footer.isRefreshing()
        //            } else {
        //                return false
        //            }
        //        }
    }
    
    public var pageSize: Int {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedPageSizeKey) {
                return value as! Int
            }
            return 20
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedPageSizeKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
    
    public var page: Int {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.FeedPageKey) {
                return value as! Int
            }
            return 0
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.FeedPageKey,
                newValue,
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
    
    open func addRefreshHeader(_ refreshHeaderType:LEORefreshHeader.Type = LEORefreshHeader.self, callback:(LEORefreshHeader?) -> () = { _ in }) {
        let header = refreshHeaderType.init { [weak self] in
            guard let sSelf = self else { return }
            sSelf.refresh()
        }
        
        callback(header)
        
        self.collectionView.leo_header = header
        
        self.showHeader = true
    }
    
    open func addRefreshFooter(_ refreshFooterType:LEORefreshFooter.Type = LEORefreshFooter.self, callback:(LEORefreshFooter?) -> () = { _ in }) {
        let footer = refreshFooterType.init { [weak self] in
            guard let sSelf = self else { return }
            sSelf.loadMore(sSelf.page + 1)
        }
        
        callback(footer)
        
        self.collectionView.leo_footer = footer
        
        self.showFooter = true
    }
    
    open func headerBeginRefreshing() {
        self.collectionView.leo_header.beginRefreshing()
    }
    
    open func footerBeginRefreshing() {
        self.collectionView.leo_footer.beginRefreshing()
    }
    
    open func refresh() {
        self.hasMore = true
        self.loadMore(1)
    }
    
    open func loadMore(_ page:Int) {
        if !self.hasMore {
            if self.showHeader && self.collectionView.leo_header.isRefreshing() {
                self.collectionView.leo_header.endRefreshing()
            }
            if self.showFooter, self.collectionView.leo_footer != nil, self.collectionView.leo_footer.isRefreshing() {
                self.collectionView.leo_footer.endRefreshingWithNoMoreData()
            }
            return
        }
        
        self.isLoading = true
        
        if let _ = self.loadingViewModel, page == 1 {
            self.reloadData()
        } else if self.loadingView != nil, page == 1 {
            self.reloadData()
        }
        
        //执行业务逻辑
        self.loader(page, self.pageSize)
    }
    
    open func stopLoading(_ page:Int?,
                          hasMore: () -> (Bool) = { return true },
                          reloadDelay: Int = 0,
                          callback: @escaping ()->() = {}) {
        if self.showHeader && self.collectionView.leo_header.isRefreshing() {
            self.collectionView.leo_header.endRefreshing()
        }
        self.hasMore = hasMore()
        
        if self.showFooter, let footer = (self.footer ?? self.collectionView.leo_footer) {
            if self.hasMore {
                footer.resetNoMoreData()
                footer.endRefreshing()
            } else {
                footer.endRefreshingWithNoMoreData()
            }
        }
        
        if let p = page {
            self.page = p
        }
        
        callback()
        
        self.isLoading = false
        
        if reloadDelay > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(reloadDelay), execute: {
                self.reloadData()
            })
        } else {
            self.reloadData()
        }
    }
}

