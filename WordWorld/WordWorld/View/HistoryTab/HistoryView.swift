//
//  HistoryView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/06/09.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var wordLoader : WordLoader
    
    var body: some View {
        VStack {
            Text("단어 히스토리")
                .font(.custom("", size: 40))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(30)
            
            List(wordLoader.history, id: \.self) { histories in
                Section {
                    Text("\(histories.wordCount ?? 0) words")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .center) {
                        ForEach(histories.wordArray, id:\.self) { history in
                            Text("\(history)")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}
