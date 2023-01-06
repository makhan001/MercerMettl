//
//  ScreenMirroring.swift
//  Dev_Mercer_Mettl
//
//  Created by mohd-ali-khan on 21/12/22.
//

import Foundation

protocol Reflectable: AnyObject {
    func reflected() -> [String: Any?]
}

extension Reflectable {
    
    func reflected() -> [String: Any?] {
        let mirror = Mirror(reflecting: self)
        var dict: [String: Any?] = [:]
        for child in mirror.children {
            guard let key = child.label else {
                continue
            }
            dict[key] = child.value
        }
        return dict
    }
    
    var reflectedString: String {
        let reflection = reflected()
        var result = String(describing: self)
        result += " { \n"
        for (key, val) in reflection {
            result += "\t\(key): \(val ?? "null")\n"
        }
        return result + "}"
    }
    
}

extension Reflectable where Self: NSObject {
    
    func reflected() -> [String : Any?] {
        
        var count: UInt32 = 0
        
        guard let properties = class_copyPropertyList(Self.self, &count) else {
            return [:]
        }
        
        var dict: [String: Any] = [:]
        for i in 0..<Int(count) {
            let name = property_getName(properties[i])
            guard let nsKey = NSString(utf8String: name) else {
                continue
            }
            let key = nsKey as String
            guard responds(to: Selector(key)) else {
                continue
            }
            dict[key] = value(forKey: key)
        }
        free(properties)
        
        return dict
    }
    
}
