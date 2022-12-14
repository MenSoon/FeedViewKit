//
//  Utils.swift
//  CYZS
//
//  Created by Shon on 2017/9/4.
//  Copyright © 2017年 SPM. All rights reserved.
//

import Foundation

//模拟命名空间方式将这些容易重名的方法隔离

let CommonLogEnabled = false

@objc open class Utils:NSObject {
    public static func line(value: CGFloat) -> CGFloat {
        return value / UIScreen.main.scale
    }
    
    public static func debugLog<T>(_ message: T,
                  file: String = #file,
                  method: String = #function,
                  line: Int = #line)
    {
        #if DEBUG
            debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
    
    public static func commonLog<T>(_ message: T,
                                   file: String = #file,
                                   method: String = #function,
                                   line: Int = #line)
    {
        #if DEBUG
            if CommonLogEnabled {
                debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
            }
        #endif
    }
}

