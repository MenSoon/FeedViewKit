//
//  DemoOneCell.swift
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


class DemoOneCell:FeedViewCell {
    
    private var label:UILabel!
    
    override func set() {
        let vm:DemoOneCellViewModel? = self.viewModel as? DemoOneCellViewModel
        self.label.text = vm?.model
    }
    
    override func bind() {
        
    }
    
    override func layout() {
        self.label = UILabel()
        self.label.backgroundColor = .red
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        }
    }
    
    override class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 44)
    }
}
