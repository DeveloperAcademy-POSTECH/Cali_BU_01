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
    // @ObservedObject var wordLoader: WordLoader = WordLoader()
    @State private var wordArray = [String]() // 단어 배열을 담기 위한 SOT
    @State private var toModify: String = "" // 수정 / 추가할 단어를 임시로 저장할 SOT
    @State private var selectedIndex: Int = 0 // 리스트에서 사용할 인덱스를 담는 SOT (리스트의 단어 선택 시 사용)
    @State private var showModifySheet: Bool = false // 단어 수정 Sheet 활성화 여부 결정 SOT
    @State private var showAddSheet: Bool = false // 단어 추가 Sheet 활성화 여부 결정 SOT
    @State private var showActivityIndicator: Bool = true
    
    @Binding var wordCount: Int?
    
    
    var body: some View {
        // Picker를 활용하고싶은데 잘 안됨
        VStack {
        Section {
            Text("단어의 갯수를 선택하세요")
                .font(.headline)
            Picker("확인할 단어 갯수", selection: $wordCount) {
                ForEach(1...15, id:\.self) { counter in
                    // Picker에서 selection이 optional일 때 다음과 같이 tag를 활용해 binding을 걸어줄 수 있음
                    Text("\(counter)").tag(counter as Int?)
                }
            }
            .frame(width: 200, height: 80)
            .clipped()
            .pickerStyle(.inline)
//            .onAppear(perform: {
//                // 처음 View를 보여줄 때 loadData() call
//                Task {
//                    await loadData()
//                    showActivityIndicator = false
//                }
//            })
            .task {
                await loadData()
                showActivityIndicator = false
            }
            .onChange(of: wordCount) { _ in
                // 단어 갯수를 입력(변경)했을 때 loadData() call
                Task {
                    showActivityIndicator = true
                    await loadData()
                    showActivityIndicator = false
                }
            }
        }
        Spacer()
        Divider()
        
        ZStack {
            List(wordArray.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Button {
                        selectedIndex = index
                        showModifySheet.toggle()
                    } label: {
                        Text(wordArray[index])
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showModifySheet)
                    {
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
                            //  .padding()
                            Text("현재 선택된 단어는 \(wordArray[index]) 입니다")
                                .padding()
                            TextField("수정할 문자를 입력", text: $toModify)
                                .frame(width: 200, alignment: .center)
                                .textFieldStyle(.roundedBorder)
                            // 키보드 입력시 자동 대문자 비활성화
                                .textInputAutocapitalization(.never)
                                .onSubmit {
                                    wordArray[selectedIndex] = toModify
                                    showModifySheet.toggle()
                                    // Text Field 비우기
                                    toModify = ""
                                }
                            
                            Spacer()
                            Spacer()
                        }
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
                        Button("단어 추가") {
                            showAddSheet.toggle()
                        }
                        .sheet(isPresented: $showAddSheet)
                        {
                            WordAddSheet
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
                    wordArray.append(toModify)
                    showAddSheet.toggle()
                    // Text Field 비우기
                    toModify = ""
                }
            
            Spacer()
            Spacer()
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
