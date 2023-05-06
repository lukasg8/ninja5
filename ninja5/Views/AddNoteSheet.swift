//
//  AddNoteSheet.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import SwiftUI

struct AddNoteSheet: View {
    
    @ObservedObject var manager:DataManager
    @State private var noteName:String = ""
    @Binding var addNewNoteShown:Bool
    
    var body: some View {
        
        VStack {
            
            Text("Enter note name:")
            TextField("Enter note name here...", text:$noteName, onCommit: { save(noteName: noteName) })
                .textFieldStyle(.roundedBorder)
            
            Button("Create") { save(noteName: noteName)}
                        
        }
        .padding()
        
    }
    
    // MARK: Private Functions
    
    /**
     Create new note in DrawingManager (and consequently also in CoreData) after user commits
     @param noteName - name of the created Note object
     */
    private func save(noteName:String) {
        manager.addNote(note: Note(id: UUID(), canvasData: Data(), title: noteName, selected: false))
        addNewNoteShown.toggle()
    }
    
}
