//
//  DataFetcher.swift
//  CollectionDisplayCOn
//
//  Created by Stanislav Starzhevskiy on 30.03.17.
//  Copyright © 2017 Stanislav Starzhevskiy. All rights reserved.
//

protocol DataFetcher {
    typealias CompletionHandler = (Error) -> Void
    func updateData(completion:CompletionHandler?)
}
