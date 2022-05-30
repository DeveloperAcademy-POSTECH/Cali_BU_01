//
//  DataModel.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import Foundation

struct Words {
    var results : [String]
}

class WordLoader : ObservableObject {
    @Published var words = [String]()
    //@Published var count : Int? = nil
}

