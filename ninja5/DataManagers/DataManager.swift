//
//  DataManager.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import Foundation

class DataManager: ObservableObject {
    
    @Published var notes: [Note]
    @Published var tasks: [Task]
    @Published var folders: [Folder]
    
    init() {
        notes = CoreDataManager.shared.getNoteData()
        tasks = []
        folders = CoreDataManager.shared.getFolderData()

        // Add sample folders for testing
        let sampleFolder1 = Folder(id: UUID(), name: "CMSC 27200", colorName: "blue", notes: [], tasks: [], subfolders: [])
        let sampleFolder2 = Folder(id: UUID(), name: "PHIL 23200", colorName: "green", notes: [], tasks: [], subfolders: [])
        let sampleFolder3 = Folder(id: UUID(), name: "SOSC 14300", colorName: "purple", notes: [], tasks: [], subfolders: [])
        let sampleFolder4 = Folder(id: UUID(), name: "PHYS 12100", colorName: "red", notes: [], tasks: [], subfolders: [])

        folders.append(sampleFolder1)
        folders.append(sampleFolder2)
        folders.append(sampleFolder3)
        folders.append(sampleFolder4)
//        tasks = generateSampleTasks()
    }

    
    // MARK: Note functions
    func updateCanvasData(canvasData:Data, for id: UUID) {
        DispatchQueue.main.async {
            if let index = self.notes.firstIndex(where: {$0.id == id}) {
                self.notes[index].canvasData = canvasData
                CoreDataManager.shared.updateCanvasData(data: self.notes[index])
            }
        }
    }
    
    func getCanvasData(for id:UUID) -> Data {
        if let note = self.notes.first(where: {$0.id == id}) {
            return note.canvasData
        }
        return Data()
    }
    
    func addNote(note:Note) {
        notes.append(note)
        CoreDataManager.shared.addNote(note: note)
    }
        
    func deleteNote(for index: Int) {
        CoreDataManager.shared.deleteNoteData(data: notes[index])
        notes.remove(at: index)
    }
    
    
    // MARK: Folder functions
    func updateFolder(updatedFolder: Folder) {
        DispatchQueue.main.async {
            if let index = self.folders.firstIndex(where: { $0.id == updatedFolder.id }) {
                self.folders[index] = updatedFolder
                CoreDataManager.shared.updateFolder(folder: updatedFolder)
            }
        }
    }
    
    func addFolder(folder:Folder) {
        folders.append(folder)
        CoreDataManager.shared.addFolder(folder: folder)
    }
    
    func deleteFolder(for index: Int) {
        CoreDataManager.shared.deleteFolder(folder: folders[index])
        folders.remove(at: index)
    }
    
    // MARK: Task functions
    func updateTask(updatedTask: Task) {
        DispatchQueue.main.async {
            if let index = self.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                self.tasks[index] = updatedTask
                CoreDataManager.shared.updateTask(task: updatedTask)
            }
        }
    }

    func addTask(task:Task) {
        tasks.append(task)
        CoreDataManager.shared.addTask(task: task)
    }

    func deleteTask(for index: Int) {
        CoreDataManager.shared.deleteTask(task: tasks[index])
        tasks.remove(at: index)
    }
    
    func filterTasks(showCompleted: Bool, folder: Folder?) -> [Task] {
            var filteredTasks = tasks

            if !showCompleted {
                filteredTasks = filteredTasks.filter { !$0.completed }
            }

            if let folder = folder {
                filteredTasks = filteredTasks.filter { $0.folder?.id == folder.id }
            }

            return filteredTasks
        }
    
    func generateSampleTasks() -> [Task] {
            let sampleTasks = [
                Task(id: UUID(), title: "Sample Task 1", description: "Task description 1", date: Date(), folder: folders[0], completed: false),
                Task(id: UUID(), title: "Sample Task 2", description: "Task description 2", date: Date().addingTimeInterval(86400), folder: folders[0], completed: false),
                Task(id: UUID(), title: "Sample Task 3", description: "Task description 3", date: Date().addingTimeInterval(86400 * 2), folder: folders[1], completed: false)
            ]
            return sampleTasks
        }



}
