//
//  ContentView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wordVM = WordViewModel()
    @StateObject var historyVM = HistoryViewModel()
    
    var body: some View {
        
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "textformat.abc.dottedunderline")
                }
                .environmentObject(wordVM)
                .environmentObject(historyVM)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "text.book.closed")
                }
                .environmentObject(historyVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
