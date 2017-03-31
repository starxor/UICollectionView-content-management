//
//  ViewController.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textField: UITextField!
    
    var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var collectionItems: [CollectionItem] {
        
        var items = [CollectionItem]()
        
        for index in 0..<self.items.count {
            let content = CollectionItemContent.text("\(self.items[index])")
            items.append(CollectionItem(action: nil, content: content))
        }
        
        return items
    }
    
    var dataController:  CollectionViewDataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataController = CollectionViewDataController(
            collectionView: collectionView,
            dataSource: TestSource()
        )
        
        dataController.updateDataSourceItems(with: [0: collectionItems])
    }

    @IBAction func addCells() {
        if let text = textField.text,
           text.characters.count > 0 {
            
            let cmp = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let flag = cmp.reduce(true) { $0 && Int($1) != nil }
            if flag {
                let indexes = cmp.map { Int($0)! }
                var items = [CollectionItem]()
                for index in indexes {
                    let content = CollectionItemContent.text("index:\(index)")
                    let item = CollectionItem(action: nil, content: content)
                    items.append(item)
                }
                
                dataController.add(items: items, to: 0, position: .savingIndex, originalItemIndexes: indexes, completion: nil)
                return
            }
        }
        
        if let string = dataController.dataSource.items[0]?.last?.content.string {
            let intVal = Int(string) ?? 0
            let content = CollectionItemContent.text("\(intVal + 1)")
            let item = CollectionItem(action: nil, content: content)
            dataController.add(items: [item], to: 0)
        } else {
            let content = CollectionItemContent.text("0")
            let item = CollectionItem(action: nil, content: content)
            dataController.add(items: [item], to: 0)
        }
    }
    
    @IBAction func deleteCells() {
        if let items = dataController.dataSource.items[0],
           let last = items.last {
            dataController.remove(items: [last], from: 0)
        }
    }
    
    @IBAction func reload() {
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let ccell = cell as? CollectionCell {
            ccell.label.text = "\(items[indexPath.row])"
        }
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class CollectionCell: UICollectionViewCell, CollectionItemDisplay {
    @IBOutlet weak var label: UILabel!
    
    func display(item: CollectionItem) {
        switch item.content {
        case .text(let text):
            label.text = text
        default:
            return
        }
    }
}

class TestSource: CollectionViewDataSource {
    override func cellReuseIdentifire(for item: CollectionItem) -> String {
        return "Cell"
    }
}
