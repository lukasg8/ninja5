//
//  TaskCreationView.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import SwiftUI

struct TaskCreationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = Date()
    @State private var selectedFolder: Folder?
    
    let folders: [Folder]
    let onTaskAdded: (Task) -> Void
    
    init(folders: [Folder], onTaskAdded: @escaping (Task) -> Void) {
        self.folders = folders
        self.onTaskAdded = onTaskAdded
        self._selectedFolder = State(initialValue: folders.first)
    }
    
    var folderView: some View {
        Picker("Select folder", selection: $selectedFolder) {
            ForEach(folders) { folder in
                folderItemView(folder)
                    .tag(folder as Folder?)
            }
        }
        .id(selectedFolder?.id ?? folders.first?.id)
    }
    
    func folderItemView(_ folder: Folder) -> some View {
        Text(folder.name)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(folder.color)
            .foregroundColor(.white)
            .cornerRadius(5)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task")) {
                    TextField("Task title", text: $taskTitle)
                    DatePicker("Task date", selection: $taskDate, displayedComponents: [.date])
                }
                
                Section(header: Text("Folder")) {
                    folderView
                }
            }
            .navigationTitle("Add Task")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let selectedFolder = selectedFolder, !taskTitle.isEmpty {
                    let task = Task(id: UUID(), title: "Sample Task 3", description: "Task description 3", date: Date(), completed: false)
                    onTaskAdded(task)
                }
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}



