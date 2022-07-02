//
//  WordModifyView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/07/01.
//

import SwiftUI


struct WordModifyView: View {
    @EnvironmentObject var wordLoader : WordViewModel // Parent View에서 가져옴
    @Binding var showModifySheet: Bool // 단어 수정 Sheet 활성화 여부 결정 SOT
    
    var body: some View {
        VStack {
            Button {
                showModifySheet.toggle()
            } label: {
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15, alignment: .center)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("단어 수정하기")
                .font(.largeTitle)
                .padding()
            

            Text("수정할 단어를 입력하세요")
                .onAppear {
                    print(wordLoader.selectedIndex)
                }
                .padding()
            
            TextField("\(wordLoader.words[wordLoader.selectedIndex])", text: $wordLoader.toModify)
                .frame(width: 200, alignment: .center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never) // 키보드 입력시 자동 대문자 비활성화
                .onSubmit {
                    wordLoader.words[wordLoader.selectedIndex] = wordLoader.toModify
                    showModifySheet.toggle()
                    // Text Field 비우기
                    wordLoader.toModify = ""
                }
                .onDisappear {
                    wordLoader.selectedIndex = 0
                }
            Spacer()
            Spacer()
        }
    }
}
