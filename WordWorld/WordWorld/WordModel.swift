
//
//  WordModel.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
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

// MainActor를 붙여야 Warning이 뜨지 않는 이유는?
class WordLoader : ObservableObject {
    //    @Published var wordArray: Array<String> = [String]()
    //    @Published var wordCount: Int? = nil
    @Published var content: WordsHistory = WordsHistory(wordArray: [])
    @Published var history: Array<WordsHistory> = []
    //@Published var count : Int? = nil
    
    init() {
        //        self.content = WordsHistory(wordCount: nil, wordArray: [])
        //        self.history = []
    }
    
    // URL Data를 읽어오는 함수
    func loadData() async {
        // 1. 읽으려는 URL 생성
        // 입력받은 단어의 갯수에 따라 가져오는 단어의 갯수 변경
        // 단어 갯수가 optional이라서 default를 0으로 주었음
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=\(content.wordCount ?? 0)") else {
            print("Invalid URL")
            return
        }
        
        do {
            // 2. URLSession을 통한 data parsing (예시코드를 참고한 것 -> 좀 더 알아보기)
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 3. JSONDecoder().decode를 통해 Data자체를 [String] 타입으로 decode
            if let response = try? JSONDecoder().decode([String].self, from: data)
            {
                // wordLoader.words = response
                self.content.wordArray = response
            }
            
        } catch {
            print("Invalid data")
        }
    }
    
    
    func makeHistory() {
        self.history.insert(content, at: 0) // 최근에 추가한게 위에 오도록 insert 활용
    }
    
}

