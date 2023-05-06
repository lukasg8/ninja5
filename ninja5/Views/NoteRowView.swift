//
//  NoteRowView.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import SwiftUI

struct NoteRowView: View {
    
    let note: Note
    
    var body: some View {
        VStack {
            HStack {
                Text(note.title)
            }
            Divider()
                .padding(.vertical, 5)
        }
    }
}

struct NoteRowView_Previews: PreviewProvider {

    static let note = Note(id: UUID(), canvasData: Data(), title: "Homework 1", selected: false)
    static var previews: some View {
        NoteRowView(note:note)
    }
}
