//
//  CollectionItemContent.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import Foundation

enum CollectionItemContent {
    case empty
    case text(_: String)
}

extension CollectionItemContent: Equatable {
    public static func ==(lhs: CollectionItemContent, rhs: CollectionItemContent) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.text(let ltext), .text(let rtext)):
            return ltext == rtext
        default:
            return false
        }
    }
}
