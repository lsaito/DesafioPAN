//
//  Serializable.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//
// Fonte: https://stackoverflow.com/questions/31971256/how-to-convert-a-swift-object-to-a-dictionary

import Foundation

protocol Serializable {}

extension Serializable {
    func toDictionary() -> [String: Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
