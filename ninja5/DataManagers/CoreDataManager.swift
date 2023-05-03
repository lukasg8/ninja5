//
//  CoreDataManager.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name:"NinjaModel")
        container.loadPersistentStores { (storeDesc, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: Folder functions
    private func getFolderEntity(by id: UUID) -> FolderEntity? {
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result.first
        } catch {
            print("Fetching FolderEntity by ID failed.")
        }

        return nil
    }

    func addFolder(folder:Folder) {
        let folderEntity = FolderEntity(context: persistentContainer.viewContext)
        
        folderEntity.id = folder.id
        folderEntity.name = folder.name
        folderEntity.colorName = folder.colorName
        
        saveContext()
    }
    
    
    func getFolderData() -> [Folder] {
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        var fetchResults = [Folder]()

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result {
                let folder = Folder(
                    id: data.id ?? UUID(),
                    name: data.name ?? "",
                    colorName: data.colorName ?? "#0000FF",
                    notes: [], tasks: [], subfolders: [])
                fetchResults.append(folder)
            }
        } catch {
            print("Fetching FolderEntity failed.")
        }

        return fetchResults
    }
    
    
    func updateFolder(folder: Folder) {
        guard let folderEntity = getFolderEntity(by: folder.id) else {
            print("Failed to find FolderEntity with id \(folder.id).")
            return
        }
        
        folderEntity.name = folder.name
        folderEntity.colorName = folder.colorName
        
        saveContext()
    }
    
    
    func deleteFolder(folder: Folder) {
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        request.includesPropertyValues = false // improve performance
        request.predicate = NSPredicate(format: "id == %@", folder.id as CVarArg)
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for folderEntity in results {
                persistentContainer.viewContext.delete(folderEntity)
            }
            saveContext()
        } catch {
            print("Error deleting FolderEntity from database.")
        }
    }

    
    
    // MARK: Note functions
    private func getNoteEntity(by id: UUID) -> NoteEntity? {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result.first
        } catch {
            print("Fetching NoteEntity by ID failed.")
        }

        return nil
    }
    
    
    func addNote(note:Note) {
        let noteEntity = NoteEntity(context: persistentContainer.viewContext)
        
        noteEntity.id = note.id
        noteEntity.canvasData = note.canvasData
        noteEntity.title = note.title
        
        if let folder = note.folder {
            let folderEntity = getFolderEntity(by: folder.id)
            noteEntity.folder = folderEntity
        }
        
        saveContext()
    }
    
    func getNoteData() -> [Note] {
        let request:NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        var fetchResults = [Note]()

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result {
                fetchResults.append(Note(id: data.id ?? UUID(), canvasData: data.canvasData ?? Data(), title: data.title ?? "", selected: false))
            }
        } catch {
            print("Fetching Note failed.")
        }

        return fetchResults
    }
    
    /**
     Update canvas data for specific NoteDataEntity object with data changes from its corresponding Note object
     @param data - the canvasData to update the NoteDataEntity with
     */
    func updateCanvasData(data:Note) {
        let request:NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", data.id as CVarArg)
        request.predicate = predicate

        do {
            let results = try persistentContainer.viewContext.fetch(request)
            let object = results.first

            object?.setValue(data.canvasData, forKey: "canvasData")
            saveContext()
        } catch {
            print("Error saving NoteEntity update.")
        }
    }
    
    
    func deleteNoteData(data:Note) {
        let request:NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.includesPropertyValues = false
        let predicate = NSPredicate(format:"id == %@", data.id as CVarArg)
        request.predicate = predicate

        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for item in results {
                persistentContainer.viewContext.delete(item)
            }
            saveContext()
        } catch {
            print("Error deleting NoteEntity from database.")
        }
    }
    
    func updateNote(note: Note) {
        guard let noteEntity = getNoteEntity(by: note.id) else {
            print("Failed to find NoteEntity with id \(note.id).")
            return
        }
        
        noteEntity.title = note.title
        noteEntity.canvasData = note.canvasData
        
        saveContext()
    }
    
    
    // MARK: Task functions
    private func getTaskEntity(by id: UUID) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result.first
        } catch {
            print("Fetching TaskEntity by ID failed.")
        }

        return nil
    }
    
    
    func addTask(task:Task) {
        let taskEntity = TaskEntity(context: persistentContainer.viewContext)
        
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.date = task.date
        
        if let folder = task.folder {
            let folderEntity = getFolderEntity(by: folder.id)
            taskEntity.folder = folderEntity
        }
        
        saveContext()
    }
    
    
    func getTaskData() -> [Task] {
        let request:NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        var fetchResults = [Task]()

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result {
                fetchResults.append(Task(id: data.id ?? UUID(), title: data.title ?? "Untitled Task", date: data.date ?? Date()))
            }
        } catch {
            print("Fetching Task failed.")
        }

        return fetchResults
    }
    
    func updateTask(task: Task) {
        guard let taskEntity = getTaskEntity(by: task.id) else {
            print("Failed to find TaskEntity with id \(task.id).")
            return
        }
        
        taskEntity.title = task.title
        taskEntity.date = task.date
        
        saveContext()
    }
    
    func deleteTask(task: Task) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.includesPropertyValues = false
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for taskEntity in results {
                persistentContainer.viewContext.delete(taskEntity)
            }
            saveContext()
        } catch {
            print("Error deleting TaskEntity from database.")
        }
    }

    
    
}
