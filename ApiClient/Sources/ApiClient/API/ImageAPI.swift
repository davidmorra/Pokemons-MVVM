//
//  File.swift
//  
//
//  Created by Davit on 19.05.24.
//

import Foundation
import Common

///https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/041.png

public enum ImageAPI: Requestable {
    case imageFor(Int)
    case path(String)
    
    public var path: String {
        switch self {
        case let .imageFor(id):
            let id = String(format: "%03d", id)
            return "fanzeyi/pokemon.json/master/images/\(id).png"
        case let .path(path):
            return path
        }
    }
    
}
