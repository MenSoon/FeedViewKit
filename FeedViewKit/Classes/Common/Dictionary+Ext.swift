//
//  Dictionary.ext.swift
//  LeoCommon
//
//  Created by Shon on 2017/8/8.
//  Copyright © 2017年 Shon. All rights reserved.
//

import Foundation

extension Dictionary {
    public func string() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String.init(data: data, encoding: .utf8)
        }
        return nil
    }
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    public func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

public func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}


