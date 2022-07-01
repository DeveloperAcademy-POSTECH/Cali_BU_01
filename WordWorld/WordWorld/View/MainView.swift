//
//  MainView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//
// (05.23) 랜덤하게 생성하고 싶은 단어의 갯수 설정 (1~15), 조건만족시키지 않으면 유저에게 알리고 화면 이동 X
// Source of Truth: 단어의 갯수, 단어 배열? / Alert를 보여줄지 말지
// 단어 배열은 다시 불러와서 생성해야할까? ✅
// 보여주는 갯수만 다르게 하면 될까?

import SwiftUI

struct MainView: View {
    // State로 하니까 뷰가 생성될 때 마다 랜덤 단어들이 계속해서 초기화됨
    // Source of Truth를 상위 View에서 StateObject로 선언
    @EnvironmentObject var wordLoader: WordLoader // WordModel에 SOT 있음
    @State private var alertValid: Bool = false // Alert 여부 SOT2
    @State private var navigationValid: Bool = false // Navigation Active SOT3
    
    var body: some View {
        NavigationView {
            VStack {
                Text("WordWorld")
                    .font(.custom("", size: 40))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(30)
                
                Spacer()
                
                Text("단어의 갯수를 입력하세요")
                    .font(.title)
                
                // 단어의 갯수를 TextField활용해 입력받음
                TextField("Enter number 1-15", value: $wordLoader.content.wordCount, format: .number)
                    .frame(width: 200, alignment: .center)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .keyboardType(.numberPad)
                
                Button {
                    // 단어의 갯수 입력이 제대로 되어있는지 확인
                    alertValid = checkCountInvalid()
                    Task {
                        await wordLoader.loadData()
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .frame(width: 150, height: 60)
                            .foregroundColor(.gray)
                        
                        Text("제출하기")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: RandomListView(wordLoader: wordLoader), isActive: $navigationValid) {
                    // 처음에는 label을 만들었지만 사용에 불편한 점이 있어 제외
                }
            }
            .alert(isPresented: $alertValid) {
                // 잘못된 값이 들어간다면 Alert
                Alert(title: Text("유효하지 않은 입력값"), message: Text("1-15 범위의 숫자를 입력해 주세요"))
            }
            .navigationTitle("Main")
            .navigationBarHidden(true)
        }
    }
    
    
    // 단어의 갯수를 설정할 때 1이상 15이하가 아닐 경우 true 반환 (Invalid)
    func checkCountInvalid() -> Bool {
        // wordCount가 optional이라서 optional binding 처리
        if let count = wordLoader.content.wordCount {
            if count < 1 || count > 15 {
                // 잘못된 값이 들어올 경우 입력값 초기화
                wordLoader.content.wordCount = nil
                return true
            }
        } else {
            // optional일 때 alert 띄우기
            return true
        }
        navigationValid.toggle()
        return false
    }
}

