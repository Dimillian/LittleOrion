//
//  ResourcesLoader.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 24/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit

class ResourcesLoader {
    
    static func loadDicResource(name: String) -> [String: AnyObject]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let dic = NSDictionary(contentsOfFile: path) as? [String : AnyObject] {
            return dic
        }
        return nil
    }
    
    static func loadTextResource(name: String) -> [String : String]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let dic = NSDictionary(contentsOfFile: path) as? [String : String] {
            return dic
        }
        return nil
    }

    static func loadArrayTextResource(name: String) -> [String]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let dic = NSArray(contentsOfFile: path) as? [String] {
            return dic
        }
        return nil
    }

    static func loadModifierResource(name: String) -> [String : Float]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let dic = NSDictionary(contentsOfFile: path) as? [String : Float] {
            return dic
        }
        return nil
    }
    
    static func loadDimensionResource(name: String, dimensionName: String) -> Size? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let dic = NSDictionary(contentsOfFile: path) {
            if let sizeDic = dic[dimensionName] as? [String: Int],
                let width = sizeDic["width"],
                let height = sizeDic["height"] {
                return Size(width: Int32(width), height: Int32(height))
            }
        }
        return nil
    }
}
