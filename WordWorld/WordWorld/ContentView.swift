//
//  ContentView.swift
//  WordWorld
//
//  Created by DongKyu Kim on 2022/05/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MainView()
            // RandomListView에서 자꾸 상단에 space가 생기는 현상이 있었음
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
