//
//  RandomListView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//
// (05.27) Picker에서 selection을 optional 값으로 하니 선택이 되지 않았다 (unwrapping 방법?)
// (06.02) Picker 내의 ForEach 항목에 .tag()를 통해 optional 처리가 가능하게 되었다.
// (06.04) Sheet를 추가해서 단어 수정이 가능하게 됨, 질문 : sheet에서 단어 index를 받을 때 왜 저장한 값은 사용이 안되나?


import SwiftUI

struct RandomListView: View {
    @ObservedObject var wordLoader : WordViewModel // Parent View에서 가져옴
    @EnvironmentObject var historyVM : HistoryViewModel
    
    @State private var showModifySheet: Bool = false // 단어 수정 Sheet 활성화 여부 결정 SOT
    @State private var showAddSheet: Bool = false // 단어 추가 Sheet 활성화 여부 결정 SOT
    @State private var showAlert: Bool = false // 단어 히스토리에 추가 알림 활성화 여부
    
    @Binding var showActivityIndicator: Bool // 로딩 화면 활성화 여부
    
    var body: some View {
        // Picker를 활용하고싶은데 잘 안됨
        VStack {
            Section {
                Text("단어의 갯수를 선택하세요")
                    .font(.headline)
                Picker("확인할 단어 갯수", selection: $wordLoader.count) {
                    ForEach(1...15, id:\.self) { counter in
                        // Picker에서 selection이 optional일 때 다음과 같이 tag를 활용해 binding을 걸어줄 수 있음
                        Text("\(counter)").tag(counter as Int?)
                    }
                }
                .frame(width: 200, height: 80)
                .clipped()
                .pickerStyle(.inline)
                .onChange(of: wordLoader.count) { _ in
                    // 단어 갯수를 입력(변경)했을 때 loadData() call
                    Task {
                        showActivityIndicator = true
                        await wordLoader.loadData()
                        showActivityIndicator = false
                    }
                }
            }
            Spacer()
            Divider()
            
            ZStack {
                List(wordLoader.words.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Button {
                            wordLoader.selectedIndex = index
                            showModifySheet.toggle()
                        } label: {
                            Text(wordLoader.words[index])
                                .foregroundColor(.black)
                        }
                        
                    }
                }
                
                // ProgressView를 보여주기
                if showActivityIndicator {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                }
            }
            
        }
        .sheet(isPresented: $showModifySheet) {
            WordModifyView(showModifySheet: $showModifySheet)
                .environmentObject(wordLoader)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    // 리스트에 단어 추가하기 버튼
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .sheet(isPresented: $showAddSheet) {
                        WordAddSheet
                    }
                    
                    // 히스토리에 추가하기 버튼
                    Button {
                        historyVM.getWords(words: wordLoader.words, count: wordLoader.words.count)
                        historyVM.makeHistory()
                        showAlert = true
                    } label: {
                        Image(systemName: "bookmark.circle")
                    }
                    .alert("히스토리에 추가되었습니다!", isPresented: $showAlert) {
                        Button("확인", role: .cancel) { }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // 단어 추가를 위한 시트
    private var WordAddSheet: some View {
        VStack {
            Button {
                showAddSheet.toggle()
            } label: {
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15, alignment: .center)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("단어 추가하기")
                .font(.largeTitle)
                .padding()
            
            TextField("추가할 문자를 입력", text: $wordLoader.toModify)
                .frame(width: 200, alignment: .center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    wordLoader.words.append(wordLoader.toModify)
                    showAddSheet.toggle()
                    
                    // Text Field 비우기
                    wordLoader.toModify = ""
                }
            
            Spacer()
            Spacer()
        }
    }
}


