//
//  ContentView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "textformat.abc.dottedunderline")
                }
            
            //            HistoryView()
            //                .tabItem {
            //                    Label("History", systemImage: "text.book.closed")
            //                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
