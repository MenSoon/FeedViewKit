//
//  FeedView+DataSource.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension FeedView:UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sectionViewModels.count == 0 {
            return 0
        }
        return self.sectionViewModels[section].items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let reuseIdentifier = String(describing: cellVM.cellClass(nil))
        
        if self.registerDict[reuseIdentifier] == nil {
            collectionView.register(cellVM.cellClass(nil), forCellWithReuseIdentifier: reuseIdentifier)
            self.registerDict[reuseIdentifier] = reuseIdentifier
        }
        
        let cell:FeedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewCell
        cell.viewModel = cellVM
        cell.parentFeedView = self
        return cell
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionViewModels.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionVM = self.sectionViewModels[indexPath.section]
        if (kind == UICollectionView.elementKindSectionHeader || kind == LEOCollectionElementKindSectionHeader), let header = sectionVM.header {
            
            let reuseIdentifier = String(describing: header.sectionClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                collectionView.register(header.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                self.registerDict[reuseIdentifier] = reuseIdentifier
            }
            
            let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
            view.viewModel = sectionVM.header
            view.parentFeedView = self
            return view
        } else if (kind == UICollectionView.elementKindSectionFooter || kind == LEOCollectionElementKindSectionFooter), let footer = sectionVM.footer {
            let reuseIdentifier = String(describing: footer.sectionClass(nil))
            
            if self.registerDict[reuseIdentifier] == nil {
                collectionView.register(footer.sectionClass(nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                self.registerDict[reuseIdentifier] = reuseIdentifier
            }
            
            let view:FeedViewSectionHeaderOrFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedViewSectionHeaderOrFooter
            view.viewModel = sectionVM.footer
            view.parentFeedView = self
            return view
        }
        return UICollectionReusableView.init()
    }
}

