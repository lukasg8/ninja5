import SwiftUI

struct TasksByDateView: View {
    @EnvironmentObject var manager: DataManager
    
    @State private var showCompleted = false
    @State private var selectedFolder: Folder?
    @State private var tasks: [Task] = []
    @State private var showingQR: Bool = false
    @State private var showAddTaskSheet: Bool = false
    @State private var showDrawingView = false
    
    let studentName:String

    var body: some View {
        VStack {
            HStack {
                
                Text("Welcome \(studentName)")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    showCompleted.toggle()
                }) {
                    if showCompleted {
                        Text("Hide completed")
                            .font(.headline)
                            .foregroundColor(showCompleted ? .blue : .white)
                            .padding(8)
                            .background(showCompleted ? Color.gray.opacity(0.2) : .blue)
                            .cornerRadius(10)
                    } else {
                        Text("Show completed")
                            .font(.headline)
                            .foregroundColor(showCompleted ? .blue : .white)
                            .padding(8)
                            .background(showCompleted ? Color.gray.opacity(0.2) : .blue)
                            .cornerRadius(10)
                    }
                }
                .onChange(of: showCompleted) { _ in
                    updateTaskList()
                }


                Picker("Folder Filter", selection: $selectedFolder) {
                    Text("All Folders").tag(nil as Folder?)
                    ForEach(manager.folders) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedFolder) { _ in
                    updateTaskList()
                }
                
                // Add task
                Button(action: {
                    showAddTaskSheet = true
                }, label: {
                    Image(systemName: "plus")
                })
                .padding(.trailing)
                
                // QR Code
                Button(action: {
                    showingQR = true
                }, label: {
                    Image(systemName: "qrcode")
                })
                .padding(.trailing)
                
            }
            .padding(.bottom,0)
            .padding(.top)
            .sheet(isPresented: $showingQR, content: {
                QRCodeScannerView { code in
                    fetchTask(from: code)
                    showingQR = false
                }
            })
            .sheet(isPresented: $showAddTaskSheet) {
                AddTaskSheet()
                    .environmentObject(manager)
            }
            .onChange(of: showAddTaskSheet) { isPresented in
                if !isPresented {
                    updateTaskList()
                }
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    if manager.tasks.isEmpty {
                        VStack {
                            Spacer()
                            Text("Congratulations! You have no tasks at the moment.")
                                .font(.system(size:15))
                        }
                        .frame(maxHeight:.infinity)
                    } else {
                        ForEach(datesWithTasks(), id: \.self) { date in
                            let filteredIndices = filteredTasksIndices(for: date)
                            if !filteredIndices.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(dateString(from: date))
                                        .font(.title2)
                                        .bold()

                                    ForEach(filteredIndices, id: \.self) { index in
                                        if showCompleted || !manager.tasks[index].completed {
                                            TaskRowView(task: $manager.tasks[index], showDrawingView: $showDrawingView)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .background(
                    NavigationLink(destination: DrawingView(manager: manager, id: tasks.first(where: { $0.note != nil })?.note?.id ?? UUID()), isActive: $showDrawingView) {
                        EmptyView()
                    }
                    .opacity(0) // Hide the NavigationLink
                )
                .padding(.top,0)
                .padding(.horizontal)
            }
        }
        .onAppear {
            updateTaskList()
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

    private func updateTaskList() {
        tasks = manager.filterTasks(showCompleted: showCompleted, folder: selectedFolder)
    }

    private func datesWithTasks() -> [Date] {
        let uniqueDates = Set(manager.tasks.map { Calendar.current.startOfDay(for: $0.date) })
        return uniqueDates.sorted()
    }

    private func filteredTasksIndices(for date: Date) -> [Int] {
        return manager.tasks.indices.filter { index in
            let task = manager.tasks[index]
            return Calendar.current.isDate(task.date, inSameDayAs: date) && (showCompleted || !task.completed)
        }
    }

    private func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct TasksByDateView_Previews: PreviewProvider {
    
    static var studentName = "Lukas"
    
    static var previews: some View {
        TasksByDateView(studentName: studentName)
            .previewLayout(.sizeThatFits)
            .environmentObject(DataManager())
    }
}
