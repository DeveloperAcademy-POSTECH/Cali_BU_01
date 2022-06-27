//
//  RandomListView2.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/06/23.
//

import SwiftUI

struct RandomListView2: View {
    @StateObject var wordLoader : WordLoader // Parent View에서 가져옴
    @State private var toModify: String = "" // 수정 / 추가할 단어를 임시로 저장할 SOT
    @State private var selectedIndex: Int = 0 // 리스트에서 사용할 인덱스를 담는 SOT (리스트의 단어 선택 시 사용)
    @State private var showModifySheet: Bool = false // 단어 수정 Sheet 활성화 여부 결정 SOT
    @State private var showAddSheet: Bool = false // 단어 추가 Sheet 활성화 여부 결정 SOT
    @State private var showAlert: Bool = false // 단어 히스토리에 추가 알림 활성화 여부
    @State private var showActivityIndicator: Bool = true // 로딩 화면 활성화 여부
    
    // @State private var selectedOption = "option"
    // let pickerOption = ["목록에 단어 추가", "히스토리 추가"]
    
    var body: some View {
        // Picker를 활용하고싶은데 잘 안됨
        VStack {
            Section {
                Text("단어의 갯수를 선택하세요")
                    .font(.headline)
                Picker("확인할 단어 갯수", selection: $wordLoader.content.wordCount) {
                    ForEach(1...15, id:\.self) { counter in
                        // Picker에서 selection이 optional일 때 다음과 같이 tag를 활용해 binding을 걸어줄 수 있음
                        Text("\(counter)").tag(counter as Int?)
                    }
                }
                .frame(width: 200, height: 80)
                .clipped()
                .pickerStyle(.inline)
                .task {
                    await wordLoader.loadData()
                    showActivityIndicator = false
                }
                .onChange(of: wordLoader.content.wordCount) { _ in
                    // 단어 갯수를 입력(변경)했을 때 loadData() call
                    showActivityIndicator = true
                    Task {
                        await wordLoader.loadData()
                    }
                    showActivityIndicator = false
                }
            }
            Spacer()
            Divider()
            
            ZStack {
                List(wordLoader.content.wordArray.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Button {
                            selectedIndex = index
                            print(selectedIndex)
                            showModifySheet.toggle()
                        } label: {
                            Text(wordLoader.content.wordArray[index])
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showModifySheet)
                        {
                            WordModifySheet
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    // 리스트에 단어 추가하기 버튼
                    Button {
                        showAddSheet.toggle()
                        
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .sheet(isPresented: $showAddSheet)
                    {
                        WordAddSheet
                    }
                    
                    // 히스토리에 추가하기 버튼
                    Button {
                        wordLoader.makeHistory(wordCount: wordLoader.content.wordCount ?? 0, wordArray: wordLoader.content.wordArray)
                        showAlert = true
                    } label: {
                        Image(systemName: "bookmark.circle")
                    }
                    .alert("히스토리에 추가되었습니다!", isPresented: $showAlert) {
                        Button("확인", role: .cancel)
                            { }
                        }
                }
            }
        }
        
        
        
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var WordAddSheet: some View { // 단어 추가를 위한 시트
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
            
            TextField("추가할 문자를 입력", text: $toModify)
                .frame(width: 200, alignment: .center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    wordLoader.content.wordArray.append(toModify)
                    showAddSheet.toggle()
                    
                    // Text Field 비우기
                    toModify = ""
                }
            
            Spacer()
            Spacer()
        }
    }
    
    private var WordModifySheet: some View {
        // 단어 수정을 위한 시트
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
            
            
            // 여기서 selectedIndex를 하면 왜 0번 index가 나올까? (print는 정상적으로 작동)
            // Text("현재 선택된 문자는 \(wordArray[selectedIndex]) 입니다")
            Text("현재 선택된 단어는 \(wordLoader.content.wordArray[selectedIndex]) 입니다")
                .padding()
            TextField("수정할 문자를 입력", text: $toModify)
                .frame(width: 200, alignment: .center)
                .textFieldStyle(.roundedBorder)
            // 키보드 입력시 자동 대문자 비활성화
                .textInputAutocapitalization(.never)
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
