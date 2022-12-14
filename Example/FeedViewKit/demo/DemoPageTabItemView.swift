//
//  DemoPageTabItemView.swift
//  LeoCommon
//
//  Created by  Shon on 2017/9/13.
//  Copyright © 2017年  Shon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FeedViewKit

class DemoPageTabItemView:PageTabItemView {
    var label:UILabel!
    
    var text:String! {
        didSet {
            self.label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
        self.label = UILabel()
        self.label.backgroundColor = generateRandomColor()
        self.label.textAlignment = .center
        self.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(5)
            make.right.bottom.equalTo(self).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tabWidth() -> CGFloat {
        return 80
    }
}
