//
//  CollectionDataSource.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    typealias SectionIndex = Int
    var items = [SectionIndex: [CollectionItem]]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = items[indexPath.section]?[indexPath.row] else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultReuseIdentifire, for: indexPath)
        }
        
        let reuseIdentifier = cellReuseIdentifire(for: item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let itemDisplay = cell as? CollectionItemDisplay {
            itemDisplay.display(item: item)
        }
        
        return cell
    }
    
    // MARK: Cell reuse data
    
    /// Идентификатор по умолчанию. Для ячеек - заглушек.
    var defaultReuseIdentifire: String {
        return "CollectionDataSource.defaultReuseIdentifire"
    }
    
    /// Идентификатор переиспользуемой ячейки для конкретного элемента коллекции.
    /// - parameter for: элемент коллекции для которого мы хотим узнать идентификатор.
    ///
    /// - returns: Идентификатор переиспользования
    func cellReuseIdentifire(for item: CollectionItem) -> String {
        assert(false, "cellReuseIdentifire должен быть переопределен!")
    }
    
    /// Данные для регистрации переиспользуемых компонентов UICollectionView.
    ///
    /// Возвращаем описание переиспольуемых элементов, необходимых для правильного отображения нашей коллекции.
    ///
    /// - returns: [CollectionViewReusableItemRegistrationData]
    func reusableItemsRegistrationData() -> [CollectionViewReusableItemRegistrationData] {
        return []
    }
}
