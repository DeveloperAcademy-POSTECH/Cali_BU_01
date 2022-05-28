//
//  RandomListView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import SwiftUI

struct RandomListView: View {
    @ObservedObject var wordLoader: WordLoader
    
    var body: some View {
        Section {
            TextField("Enter number 1-15", value: $wordLoader.count, format: .number)
                .padding()
                .onSubmit {
                    Task {
                        await loadData()
                    }
                }
        } header: {
            Text("단어의 갯수를 선택하세요!")
        }
        
        Section{
            List(wordLoader.words, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item)
                }
            }
            .task {
                // sleep이 일어나게 한다
                await loadData()
            }
        }
        
    }
    
    func loadData() async {
        // 1. 읽으려는 URL 생성
        // 입력받은 단어의 갯수에 따라 가져오는 단어의 갯수 변경
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=" + String(wordLoader.count ?? 1)) else {
            print("Invalid URL")
            return
        }
        
        do {
            // 2. String(contentsOf:)를 통해 Data자체를 String으로 저장,throws 하므로 error처리
            let decodedResponse = try String(contentsOf: url)
            wordLoader.words = stringToArray(input: decodedResponse)
            
        } catch {
            print("Invalid data")
        }
        
    }
}
