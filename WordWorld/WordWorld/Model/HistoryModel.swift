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

class HistoryViewModel : ObservableObject {
    private var content: WordsHistory
    @Published var histories: [WordsHistory]

    init() {
        self.content = WordsHistory(wordCount: 0, wordArray: [""])
        self.histories = []
    }

    func makeHistory() {
        self.histories.insert(content, at: 0)
    }
    
    func getWords(words: [String], count: Int) {
        self.content.wordArray = words
        self.content.wordCount = count
    }
}
