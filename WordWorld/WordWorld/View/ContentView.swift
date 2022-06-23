//
//  ContentView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wordLoader = WordLoader()
    
    var body: some View {
        
//        TabView {
//            MainView()
//                .tabItem {
//                    Label("Main", systemImage: "textformat.abc.dottedunderline")
//                }
//
//            HistoryView()
//                .tabItem {
//                    Label("History", systemImage: "text.book.closed")
//                }
//        }
        
        TabView {
            MainView2()
                .tabItem {
                    Label("Main", systemImage: "textformat.abc.dottedunderline")
                }
                .environmentObject(wordLoader)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "text.book.closed")
                }
                .environmentObject(wordLoader)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
