//
//  CollectionDataController.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import UIKit

class CollectionViewDataController {
    unowned var collectionView: UICollectionView
    var dataSource: CollectionViewDataSource
    init(collectionView cview: UICollectionView, dataSource source: CollectionViewDataSource) {
        collectionView = cview
        dataSource = source
        collectionView.dataSource = dataSource
    }
}

extension CollectionViewDataController: DataFetcher {
    typealias CollectionViewUpdateCompletionHandler = (Bool) -> Void
    
    func updateData(completion:CompletionHandler?) {
        assert(false, "updateData должен быть переопределен!")
    }
    
    typealias SectionIndex = CollectionViewDataSource.SectionIndex
    func updateDataSourceItems(with items: [SectionIndex: [CollectionItem]]) {
        dataSource.items = items
        collectionView.reloadData()
    }
}

extension CollectionViewDataController {
    // MARK: Adding items
    
    func add(items: [CollectionItem], to section: SectionIndex) {
        add(items: items, to: section, completion: nil)
    }
    
    func add(items: [CollectionItem], toBeginingOf section: SectionIndex) {
        add(items: items, to: section, position: .begining, originalItemIndexes: [], completion: nil)
    }
    
    func add(items: [CollectionItem], to section: SectionIndex, completion: CollectionViewUpdateCompletionHandler?) {
        add(items: items, to: section, position: .end, originalItemIndexes: [], completion: completion)
    }
    
    func add(items: [CollectionItem], to section: SectionIndex, position: PositionInSection, originalItemIndexes: [Int],
             completion: CollectionViewUpdateCompletionHandler?) {
        var existing = dataSource.items[section] ?? []
        
        let newIndexPaths = indexPathsForInserting(
            items: items, in: section, containing: existing,
            targetPosition: position, originalItemIndexes: originalItemIndexes
        )
        
        switch position {
        case .begining:
            existing.insert(contentsOf: items, at: 0)
        case .end:
            existing.append(contentsOf: items)
        case .savingIndex:
            if existing.count == 0 {
                existing.append(contentsOf: items)
            } else {
                _ = (0..<items.count).map {
                    var index = originalItemIndexes[$0]
                    if index > existing.count {
                        index = existing.count
                    }
                    
                    existing.insert(items[$0], at: index)
                }
            }
        }
        
        dataSource.items[section] = existing
        
        collectionView.performBatchUpdates(
            { [unowned self] in self.collectionView.insertItems(at: newIndexPaths) }
            ,completion: completion
        )
    }
}

extension CollectionViewDataController {
    // MARK: Removing items
    func remove(items: [CollectionItem], from section: SectionIndex) {
        remove(items: items, from: section, completion: nil)
    }
    
    func remove(items: [CollectionItem], from section: SectionIndex, completion: CollectionViewUpdateCompletionHandler?) {
        let pathsToDelete: [IndexPath]
        
        guard
            var existing = dataSource.items[section],
            let _ = existing.first,
            let _ = existing.last
            else {
                print("nothing to remove from section: \(section) \n dataSource: \(String(describing: dataSource))")
                return
        }
        
        let isSubset = items.map { item in return existing.contains(item) }.reduce(true) { $0 == $1 }
        
        guard
            isSubset
            else {
                print("items to remove is not a subset of items in section: \(section) of dataSource: \(String(describing: dataSource))")
                return
        }
        
        let rows = items.map { existing.index(of: $0)! }
        pathsToDelete = rows.map { IndexPath(row: $0, section: section) }
        for item in items {
            existing.remove(at: existing.index(of: item)!)
        }
        
        dataSource.items[section] = existing
        
        collectionView.performBatchUpdates(
            { [unowned self] in self.collectionView.deleteItems(at: pathsToDelete) },
            completion: completion
        )
    }
}

extension CollectionViewDataController {
    // MARK: Moving Items
    
    func move(items: [CollectionItem], from: SectionIndex, toEndOf destination: SectionIndex) {
        
    }
    
    func move(items: [CollectionItem], from: SectionIndex, toBeginingOf destination: SectionIndex) {
        
    }
    
    func move(items: [CollectionItem], from: SectionIndex, withSavingIndexto destination: SectionIndex) {
        
    }
    
    func move(items: [CollectionItem], from: SectionIndex, toEndOf destination: SectionIndex,
              completion: CollectionViewUpdateCompletionHandler?) {
        
    }
    
    func move(items: [CollectionItem], from: SectionIndex, toBeginingOf destination: SectionIndex,
              completion: CollectionViewUpdateCompletionHandler?) {
        
    }
    
    func move(items: [CollectionItem], from: SectionIndex, withSavingIndexto destination: SectionIndex,
              completion: CollectionViewUpdateCompletionHandler?) {
        
    }
}

extension CollectionViewDataController {
    // MARK: Helper methods
    
    func indexPathsForInserting(items: [CollectionItem], in section: SectionIndex, containing existingItems: [CollectionItem],
                                targetPosition position: PositionInSection, originalItemIndexes: [Int] ) -> [IndexPath] {
        let newIndexPaths: [IndexPath]
        let range: CountableRange<Int>
        let count = items.count
        
        if position == .savingIndex {
            assert(items.count == originalItemIndexes.count, "Items count must be equal to originalItemIndexes count!")
        }
        
        
        switch position {
        case .begining:
            range = 0..<count
            newIndexPaths = range.map { IndexPath(row: $0, section: section) }
            break
        case .end:
            range = existingItems.count..<(existingItems.count + count)
            newIndexPaths = range.map { IndexPath(row: $0, section: section) }
        case .savingIndex:
            let itemsRange = 0..<items.count
            var eCount = existingItems.count
            var sortedIndexes = originalItemIndexes.sorted()
            newIndexPaths = itemsRange.map {
                var index = sortedIndexes[$0]
                if index > eCount {
                    // добавляем в конец
                    index = eCount
                }
                eCount += 1
                return IndexPath(row: index, section: section)
            }
            break
        }
        
        return newIndexPaths
    }
}

extension CollectionViewDataController {
    // MARK: Types
    
    enum PositionInSection {
        case begining
        case end
        case savingIndex
    }
}
