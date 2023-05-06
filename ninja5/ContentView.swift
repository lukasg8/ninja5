//
//  ContentView.swift
//  ninja4
//
//  Created by Lukas on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager : DataManager
    
    @State private var selectedTab = 0
    let dateHolder = DateHolder()

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(manager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            MonthCalendarView()
                .environmentObject(dateHolder)
                .environmentObject(manager)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)

            AllNotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("All Notes")
                }
                .tag(2)
        }
    }
}
