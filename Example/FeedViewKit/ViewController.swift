//
//  ViewController.swift
//  FeedViewKit
//
//  Created by 2283312765@qq.com on 09/10/2022.
//  Copyright (c) 2022 2283312765@qq.com. All rights reserved.
//

import UIKit
import FeedViewKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let feedView = FeedView.init(frame: .zero, layoutType: .flow, scrollDirection: .vertical, sticky: false)
        feedView.collectionView.backgroundColor = .orange
        self.view.addSubview(feedView)
        feedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

