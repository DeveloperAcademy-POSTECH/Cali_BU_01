
//
//  WordModel.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import Foundation


// MainActor를 붙여야 Warning이 뜨지 않는 이유는?
@MainActor class WordViewModel : ObservableObject {
    //@Published var wordArray: Array<String?>
    @Published var words: Array<String> = []
    @Published var count: Int?
    
    @Published var selectedIndex: Int = 0
    @Published var toModify: String = ""
    
    @Published var wordGroup: WordsHistory
    //@Published var count : Int? = nil
    
    init() {
        self.wordGroup = WordsHistory(wordCount: nil, wordArray: [])
    }
    
    // URL Data를 읽어오는 함수
    func loadData() async {
        // 1. 읽으려는 URL 생성
        // 입력받은 단어의 갯수에 따라 가져오는 단어의 갯수 변경
        // 단어 갯수가 optional이라서 default를 0으로 주었음
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=\(count ?? 0)") else {
            print("Invalid URL")
            return
        }
        
        do {
            // 2. URLSession을 통한 data parsing (예시코드를 참고한 것 -> 좀 더 알아보기)
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 3. JSONDecoder().decode를 통해 Data자체를 [String] 타입으로 decode
            if let response = try? JSONDecoder().decode([String].self, from: data)
            {
                self.words = response
            }
            
        } catch {
            print("Invalid data")
        }
    }
    
    func modifyWord() {
        self.words[selectedIndex] = toModify
    }
    
    func setWordCount()  {
        self.count = words.count
    }
    
    // 단어의 갯수를 설정할 때 1이상 15이하가 아닐 경우 true 반환 (Invalid)
    func checkCountInvalid() -> Bool {

        // wordCount가 optional이라서 optional binding 처리
        if let unwrappedCount = count {
            if unwrappedCount < 1 || unwrappedCount > 15 {
                // 잘못된 값이 들어올 경우 입력값 초기화
                count = nil
                return true
            }
        } else {
            // optional일 때 alert 띄우기
            return true
        }
        return false
    }
    
}

