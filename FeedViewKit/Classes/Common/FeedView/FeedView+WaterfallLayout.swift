//
//  FeedView+WaterfallLayout.swift
//  LeoCommon
//
//  Created by Shon on 2017/9/12.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension FeedView:LEOCollectionViewDelegateWaterfallLayout {
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let cellVM = self.sectionViewModels[indexPath.section].items[indexPath.row]
        let cls = cellVM.cellClass(nil)
        let size = cls.sizeThatFits(cellVM, size:self.bounds.size)
        return size
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             heightForHeaderInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        if let header = sectionVM.header {
            let cls = header.sectionClass(nil)
            let size = cls.sizeThatFits(header, size:self.bounds.size)
            return size.height
        }
        return 0
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             heightForFooterInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        if let footer = sectionVM.footer {
            let cls = footer.sectionClass(nil)
            let size = cls.sizeThatFits(footer, size:self.bounds.size)
            return size.height
        }
        return 0
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count - 1 {
            return .zero
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.sectionInset
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumLineSpacing
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  minimumColumnSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.minimumInteritemSpacing
    }
    
    open func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             columnCountForSection section: Int) -> Int {
        if section > self.sectionViewModels.count - 1 {
            return 0
        }
        let sectionVM = self.sectionViewModels[section]
        return sectionVM.columnCount
    }
}
