//
//  RandomListView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//
// (05.27) Picker에서 selection을 optional 값으로 하니 선택이 되지 않았다 (unwrapping 방법?)
// (06.02) Picker 내의 ForEach 항목에 .tag()를 통해 optional 처리가 가능하게 되었다.

import SwiftUI

struct RandomListView: View {
    // @ObservedObject var wordLoader: WordLoader = WordLoader()
    @State private var wordArray = [String]() // 단어 배열을 담기 위한 SOT
    @Binding var wordCount: Int?

    var body: some View {
        // Picker를 활용하고싶은데 잘 안됨
        Section {
            Text("단어의 갯수를 선택하세요")
                .font(.headline)
            Picker("확인할 단어 갯수", selection: $wordCount) {
                ForEach(0...15, id:\.self) { counter in
                    // Picker에서 selection이 optional일 때 다음과 같이 tag를 활용해 binding을 걸어줄 수 있음
                    Text("\(counter)").tag(counter as Int?)
                }
            }
            .pickerStyle(.automatic)
            .onAppear(perform: {
                // 처음 View를 보여줄 때 loadData() call
                Task {
                    await loadData()
                }
            })
            .onChange(of: wordCount) { _ in
                // 단어 갯수를 입력(변경)했을 때 loadData() call
                Task {
                    await loadData()
                }
            }
//            .onAppear(perform: {
//                loadCount()
//            })
        }
        
//        Section {
//            Text("단어의 갯수를 입력하세요")
//                .font(.headline)
//            // TextField를 통해 List에서 확인할 단어의 갯수를 입력받기
//            TextField("Enter number 1-15", value: $wordCount, format: .number)
//                .frame(width: 200, alignment: .center)
//                .textFieldStyle(.roundedBorder)
//                .padding(.horizontal)
//                .onSubmit {
//                    // 단어 갯수를 입력(변경)했을 때 loadData() call
//                    Task {
//                        await loadData()
//                    }
//                }
//        }
        
        List(wordArray, id: \.self) { item in
            VStack(alignment: .leading) {
                Text(item)
            }
        }
        
    }
    
    // URL Data를 읽어오는 함수
    func loadData() async {
        // 1. 읽으려는 URL 생성
        // 입력받은 단어의 갯수에 따라 가져오는 단어의 갯수 변경
        // 단어 갯수가 optional이라서 default를 0으로 주었음
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=\(wordCount ?? 0)") else {
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
                wordArray = response
            }
            
        } catch {
            print("Invalid data")
        }
        
    }
}
