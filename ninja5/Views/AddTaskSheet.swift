//
//  AddTaskSheet.swift
//  ninja5
//
//  Created by Lukas on 5/7/23.
//

import SwiftUI

struct AddTaskSheet: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var selectedFolder: Folder?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Folder")) {
                    Picker("Select Folder", selection: $selectedFolder) {
                        Text("No Folder").tag(nil as Folder?)
                        ForEach(manager.folders) { folder in
                            Text(folder.name).tag(folder as Folder?)
                        }
                    }
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveTask()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveTask() {
        let taskDate = date == nil ? Date() : date
        let task = Task(id: UUID(), title: title, description: description, date: taskDate, folder: selectedFolder, completed: false)
        manager.addTask(task: task)
    }
}

struct AddTaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskSheet()
            .environmentObject(DataManager())
    }
}

