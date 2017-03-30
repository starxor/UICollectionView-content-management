//
//  CollectionItem.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import Foundation

/// Структура для описания элемента который необходимо отобразить в UICollectionView.
struct CollectionItem {
    typealias CollectionItemAction = () -> Void
    /// Замыкание, без параметров и возвращаемого значения, для элемента коллекции,
    /// которое мы планируем вызвать когда-нибудь. (Optional)
    let action: CollectionItemAction?
    
    /// Произвольные данные для отображения. Обернутые в перечисление CollectionItemContent.
    let content: CollectionItemContent
}

extension CollectionItem: Equatable {
    public static func ==(lhs: CollectionItem, rhs: CollectionItem) -> Bool {
        return lhs.content == rhs.content
    }
}

protocol CollectionItemDisplay {
    func display(item: CollectionItem)
}
