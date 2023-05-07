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
            NoteRowView(note: .constant(Note(id: UUID(), canvasData: Data(), title: "Sample Note", selected: false, folder: Folder(id: UUID(), name: "Sample Folder", colorName: "blue", notes: [], tasks: [], subfolders: []))))
                .environmentObject(manager)
        }
    }
}
