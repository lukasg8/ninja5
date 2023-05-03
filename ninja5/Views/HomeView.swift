//
//  HomeView.swift
//  ninja4
//
//  Created by Lukas on 4/21/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var manager : DataManager
    
    @State private var showingQR: Bool = false
    @State private var studentName: String = "Lukas"
//    @State private var tasks: [Task] = []
    @State private var courses: [Folder] = [
        Folder(
            id: UUID(),
            name: "Introduction to Computer Science",
            colorName: "blue", // blue in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "Calculus I",
            colorName: "green", // green in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "Physics I",
            colorName: "purple", // red in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "English Composition",
            colorName: "red", // purple in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        )
    ]


    
    let dateHolder = DateHolder()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Welcome \(studentName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    WeekCalendarView(folders: courses)
                        .environmentObject(dateHolder)
                        .environmentObject(manager)
                        .onAppear {
                            dateHolder.currentWeekIndex = 0
                        }
                    
                    Text("Classes")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ClassGridView(courses: courses)
                    
                    Text("Upcoming Tasks")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TaskListView()
                        .environmentObject(manager)
                }
                .padding()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button(action: {
                        showingQR = true
                    }, label: {
                        Image(systemName: "qrcode")
                    })
                }
            }
            .sheet(isPresented: $showingQR, content: {
                QRCodeScannerView { code in
                    fetchTask(from: code)
                    showingQR = false
                }
            })
        }
    }
    
    func fetchTask(from url: String) {
        guard let taskURL = URL(string: url) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: taskURL) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }

            // Print the fetched data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Fetched JSON data: \(jsonString)")
            }
            
            parseTaskJSON(data: data)
        }.resume()
    }

    
    func parseTaskJSON(data: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let tasks = try decoder.decode([Task].self, from: data)
            DispatchQueue.main.async {
//                self.tasks = tasks
                for task in tasks {
                    manager.addTask(task: task)
                }
                print("Imported tasks: \(tasks)")
            }
        } catch {
            print("Error decoding JSON data: \(error.localizedDescription)")
            print("Decoding error details: \(error)")
        }
    }
    
}

struct WeeklyCalendarView: View {
    var body: some View {
        Text("Weekly Calendar Placeholder")
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ClassGridView: View {
    var courses: [Folder]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 4), spacing: 10) {
            ForEach(courses, id: \.id) { course in
                NavigationLink(destination: Text("Home view for \(course.name)")) {
                    ClassBox(course: course)
                }
            }
        }
    }
}

struct ClassBox: View {
    var course: Folder
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(course.color)
            .frame(height: 150)
            .overlay(Text(course.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white))
    }
}

struct TaskListView: View {
    @EnvironmentObject var manager: DataManager
    
    var body: some View {
        ForEach(manager.tasks, id: \.id) { task in
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Due: \(task.date)")
                    .font(.subheadline)
            }
        }
    }
}
