//
//  HistoryModel.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/07/01.
//

import Foundation

// 단어 배열을 가지는 struct
struct WordsHistory : Hashable {
    var wordCount : Int?
    var wordArray : [String]
}

//class wordArraySaver : ObservableObject {
//    @Published var content: WordsHistory
//    @Published var history: Array<WordsHistory>
//
//    init() {
//        self.content = WordsHistory(wordCount: 0, wordArray: [])
//        self.history = []
//    }
//
//    func makeHistory(wordCount: Int, wordArray: [String]) {
//        self.content.wordCount = wordCount
//        self.content.wordArray = wordArray
//        self.history.append(content)
//    }
//}
