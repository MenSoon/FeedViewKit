//
//  DemoOneCellViewModel.swift
//  CYZS
//
//  Created by  Shon on 2017/9/6.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FeedViewKit

class DemoOneCellViewModel: FeedViewCellViewModel {
    var model:String?
    
    override func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return DemoOneCell.self
    }
}
