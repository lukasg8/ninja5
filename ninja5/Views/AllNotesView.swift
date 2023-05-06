//
//  AllNotesView.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import SwiftUI

struct AllNotesView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var addNewNoteShown = false
    @State private var editShown = false
    
    let title = "All Notes"
    
    var body: some View {
        
        NavigationStack {
            VStack (alignment: .leading) {
                Text("All Notes")
                    .font(.largeTitle)
                ScrollView {
                    ForEach(manager.notes.indices, id: \.self) { index in
                        NavigationLink(value: manager.notes[index], label: { NoteRowView(note: manager.notes[index]) })
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationDestination(for: Note.self, destination: { note in DrawingView(manager: manager, id: note.id) })
            .sheet(isPresented: $addNewNoteShown, content: { AddNoteSheet(manager: manager, addNewNoteShown: $addNewNoteShown) })
            .toolbar {
                
                // Add new note button
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button(action: {
                        self.editShown = false
                        self.addNewNoteShown.toggle()
                    }, label: { Image(systemName: "plus")} )
                }
            }
        }
        
    }
                
//    // MARK: Private Functions
//    private func deleteNotes() {
//
//        for id in selectedNotes {
//            if let index = manager.notes.lastIndex(where: {$0.id == id}) {
//                manager.deleteNote(for: index)
//            }
//        }
//
//    }
    
}

struct AllNotesView_Previews: PreviewProvider {
    static var previews: some View {
        AllNotesView()
    }
}

struct AllNotesSectionHeader: View {
    
    var title: String
    
    var body: some View {
        ZStack (alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 45)
            Text(title)
                .font(.headline)
        }
    }
}
