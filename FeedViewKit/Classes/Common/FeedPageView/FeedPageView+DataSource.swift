//
//  FeedPageView+DataSource.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/16.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

private let FeedPageViewTabViewTag = 1111

extension FeedPageView {
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == self.sectionViewModels.count {
            return 1
        }
        return self.sectionViewModels[section].items.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == self.sectionViewModels.count {
            let cellVM = self.cellViewModelForPage
            let reuseIdentifier = String(describing: cellVM.cellClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                self.registerDict[reuseIdentifier] = reuseIdentifier
                collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
            }
            
            let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
            cell.viewModel = cellVM
            
            var subView = cell.contentView.viewWithTag(FeedPageViewTabViewTag)
            if subView == nil {
                if let vc = self.viewController {
                    subView = vc.pageVC.view
                } else {
                    subView = self.pageView
                }
                subView!.tag = FeedPageViewTabViewTag
                cell.contentView.addSubview(subView!)
                subView!.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(cell.contentView)
                })
            }
            return cell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionViewModels.count + 1
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == self.sectionViewModels.count {
            
            let sectionVM = self.sectionViewModelForPage
            if (kind == UICollectionView.elementKindSectionHeader || kind == LEOCollectionElementKindSectionHeader), let header = sectionVM.header {
                
                let reuseIdentifier = String(describing: header.sectionClass(nil))
                
                if self.registerDict[reuseIdentifier] == nil {
                    self.registerDict[reuseIdentifier] = reuseIdentifier
                    collectionView.register(header.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                }
                
                let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
                view.viewModel = sectionVM.header
                
                let subView = view.viewWithTag(FeedPageViewTabViewTag)
                if subView == nil {
                    self.pageTab.tag = FeedPageViewTabViewTag
                    view.addSubview(self.pageTab)
                    self.pageTab.snp.remakeConstraints({ (make) in
                        make.edges.equalTo(view)
                    })
                }
                
                return view
            }
            
            return UICollectionReusableView.init()
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
}
