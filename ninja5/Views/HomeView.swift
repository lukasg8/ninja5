//
//  HomeView.swift
//  ninja4
//
//  Created by Lukas on 4/21/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var manager : DataManager
    
    let dateHolder = DateHolder()
    
    @State private var showingQR: Bool = false
    @State private var studentName: String = "Lukas"
    @State private var courses: [Folder] = [
        Folder(
            id: UUID(),
            name: "CMSC 143",
            colorName: "blue", // blue in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "MATH 153",
            colorName: "green", // green in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "PHYS 131",
            colorName: "purple", // red in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "PHIL 272",
            colorName: "red", // purple in hexadecimal
            notes: [],
            tasks: [],
            subfolders: []
        )
    ]
    
    
    var body: some View {
        
        //        NavigationSplitView(sidebar: {
        //            SidebarView()
        //                .navigationTitle("Folders")
        //        }, detail: {
        //
        //            NavigationStack {
        //                VStack (alignment:.leading) {
        //                    HStack (alignment:.top) {
        //                        VStack (alignment:.leading) {
        //                            Text("Tasks")
        //                        }
        //                        VStack (alignment:.leading) {
        //                            Text("Calendar")
        //                            VerticalCalendarView()
        //                                .environmentObject(manager)
        //                                .environmentObject(dateHolder)
        //                        }
        //                    }
        //                    Spacer()
        //                }
        //            }
        
        NavigationStack {
            
            VStack (alignment:.leading) {
                TasksByDateView(studentName: studentName)
                    .environmentObject(manager)
                Spacer()
                Text(String(manager.tasks.count))
            }
            .padding()
        }
        
        //            NavigationStack {
        //                ScrollView {
        //                    VStack (alignment:.leading) {
        //                        HStack {
        //                            Text("Welcome \(studentName)")
        //                                .font(.largeTitle)
        //                                .bold()
        //                            Spacer()
        //                            Button(action: {showingQR = true}, label: {Image(systemName: "qrcode")})
        //                                .padding(.trailing)
        //                        }
        //
        //                        ZStack {
        //                            RoundedRectangle(cornerRadius: 20)
        //                                .foregroundColor(.white)
        //                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: -5)
        //                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        //                            WeekCalendarView(folders: courses)
        //                                .environmentObject(dateHolder)
        //                                .environmentObject(manager)
        //                                .padding()
        //                        }
        //                        .onAppear {dateHolder.currentWeekIndex = 0}
        //
        //                        GeometryReader { geometry in
        //                            HStack (alignment:.top) {
        //                                ZStack (alignment:.topLeading) {
        //                                    RoundedRectangle(cornerRadius: 20)
        //                                        .foregroundColor(.white)
        //                                        .shadow(color:.gray.opacity(0.3), radius:5,x:0,y:5)
        //                                    VStack (alignment:.leading) {
        //                                        Text("Upcoming Tasks")
        //                                            .font(.system(size:20))
        //                                            .bold()
        //                                        TaskListView()
        //                                            .environmentObject(manager)
        //                                        Spacer()
        //                                    }
        //                                    .padding()
        //                                }
        //                                .frame(width: geometry.size.width * 2/3)
        //
        //                                Spacer()
        //
        //                                ZStack {
        //                                    RoundedRectangle(cornerRadius: 20)
        //                                        .foregroundColor(.white)
        //                                        .shadow(color:.gray.opacity(0.3), radius:5,x:0,y:5)
        //                                    VStack (alignment:.leading) {
        //                                        Text("Classes")
        //                                            .font(.system(size:20))
        //                                            .bold()
        //                                        ClassGridView(courses: courses)
        //                                        Spacer()
        //                                    }
        //                                    .padding()
        //                                }
        //                                .frame(width: geometry.size.width * 1/3)
        //                            }
        //                        }
        //                    }
        //                    .padding()
        //                }
        //            }
        //        })
        //        .navigationSplitViewStyle(.prominentDetail)
        
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
        
        LazyVGrid(columns:Array(repeating:.init(),count:2),spacing:10) {
            ForEach(courses, id:\.id) { course in
                NavigationLink(destination: Text("Home view for \(course.name)")) {
                    ClassBox(course:course)
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
            .frame(height: 70)
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

