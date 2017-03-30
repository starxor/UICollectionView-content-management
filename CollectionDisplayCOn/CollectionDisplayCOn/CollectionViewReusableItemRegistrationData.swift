//
//  CollectionViewReusableItemRegistrationData.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import UIKit

enum CollectionViewReusableItemRegistrationData {
    enum RegistredType {
        case nib(_: UINib)
        case itemClass(_: AnyClass)
    }
    case cell(type: RegistredType, reuseIdentifire: String)
    case view(type: RegistredType, reuseIdentifire: String)
}
