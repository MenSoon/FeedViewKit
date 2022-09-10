//
//  DemoTwoCell.swift
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

class DemoTwoCell:FeedViewCell {
    private var label:UILabel!
    
    override func set() {
        let vm:DemoTwoCellViewModel? = self.viewModel as? DemoTwoCellViewModel
        self.label.text = vm?.model
    }
    
    override func bind() {
        
    }
    
    override func layout() {
        self.label = UILabel()
        self.label.backgroundColor = .blue
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        }
    }
    
    override class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 88)
    }
}
