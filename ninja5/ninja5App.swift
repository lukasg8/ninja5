//
//  ninja5App.swift
//  ninja5
//
//  Created by Lukas on 4/26/23.
//

import SwiftUI

@main
struct ninja5App: App {
    let manager = DataManager()

    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(manager)
            
//            TasksByDateView()
//                .environmentObject(manager)
        }
    }
}
