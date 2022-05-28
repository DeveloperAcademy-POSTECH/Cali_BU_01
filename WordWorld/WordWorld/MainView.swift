//
//  MainView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//
// 랜덤하게 생성하고 싶은 단어의 갯수 설정 (1~15), 조건만족시키지 않으면 유저에게 알리고 화면 이동 X
// Source of Truth: 단어의 갯수, 단어 배열?
// 단어 배열은 다시 불러와서 생성해야할까? 보여주는 갯수만 다르게 하면 될까?

import SwiftUI

struct MainView: View {
    // State로 하니까 뷰가 생성될 때 마다 계속해서 초기화됨
    // Source of Truth를 상위 View에서 StateObject로 선언
    @StateObject var wordLoader = WordLoader()
    @State private var alertValid: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("단어의 갯수를 입력하세요")
                    .font(.title)
                TextField("Enter number 1-15", value: $wordLoader.count, format: .number)
                    .frame(width: .infinity, alignment: .center)
                    .padding()
                    .onSubmit {
                        alertValid = checkCountInvalid()
                    }
                    .alert(isPresented: $alertValid) {
                        Alert(title: Text("Invalid input number!"), message: Text("Plese write 1-15"))
                    }
            
            
                NavigationLink(destination: RandomListView(wordLoader: wordLoader)) {
                Text("GoGo")
            }
        }
        }
    }
    
    // 단어의 갯수를 설정할 때 1이상 15이하가 아닐 경우 false 반환
    func checkCountInvalid() -> Bool {
        if let count = wordLoader.count {
            if count < 1 || count > 15 {
                wordLoader.count = nil
                return true
            }
        }
        return false
    }
}

// string으로 된 배열을 분리해서 각 element를 String 배열에 담음
// 이건 무슨 방법인가요...
func stringToArray(input: String) -> Array<String> {
    var inputString = input
    let stringArray : Array<String>
    
    inputString.removeLast()
    inputString.removeLast()
    inputString.removeFirst()
    inputString.removeFirst()
    stringArray = inputString.components(separatedBy: "\",\"")
    
    return stringArray
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
