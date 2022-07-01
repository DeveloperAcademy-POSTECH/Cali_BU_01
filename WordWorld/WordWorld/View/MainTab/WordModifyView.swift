//
//  WordModifyView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/07/01.
//

import SwiftUI


struct WordModifyView: View {
    @EnvironmentObject var wordLoader : WordLoader // Parent View에서 가져옴
    @State private var toModify: String = "" // 수정 및 추가할 단어를 임시로 저장할 SOT
    @Binding var showModifySheet: Bool // 단어 수정 Sheet 활성화 여부 결정 SOT
    @Binding var selectedIndex: Int  // 리스트에서 사용할 인덱스를 담는 SOT (리스트의 단어 선택 시 사용)
    
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
                    print(selectedIndex)
                }
                .padding()
            
            TextField("\(wordLoader.content.wordArray[selectedIndex])", text: $toModify)
                .frame(width: 200, alignment: .center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never) // 키보드 입력시 자동 대문자 비활성화
                .onSubmit {
                    wordLoader.content.wordArray[selectedIndex] = toModify
                    showModifySheet.toggle()
                    // Text Field 비우기
                    toModify = ""
                }
                .onDisappear {
                    selectedIndex = 0
                }
            Spacer()
            Spacer()
        }
    }
}
