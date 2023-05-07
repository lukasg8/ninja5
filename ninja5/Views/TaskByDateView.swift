import SwiftUI

struct TasksByDateView: View {
    @EnvironmentObject var manager: DataManager
    
    @State private var showCompleted = true
    @State private var selectedFolder: Folder?
    @State private var tasks: [Task] = []

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Show Completed")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding()
                
                Toggle(isOn: $showCompleted) {
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
                .padding(.trailing)
                .onChange(of: selectedFolder) { _ in
                    updateTaskList()
                }
            }
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(datesWithTasks(), id: \.self) { date in
                        let filteredIndices = filteredTasksIndices(for: date)
                        if !filteredIndices.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(dateString(from: date))
                                    .font(.title2)
                                    .bold()

                                ForEach(filteredIndices, id: \.self) { index in
                                    if showCompleted || !manager.tasks[index].completed {
                                        TaskRowView(task: $manager.tasks[index])
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            updateTaskList()
        }
    }

    private func updateTaskList() {
        tasks = manager.filterTasks(showCompleted: showCompleted, folder: selectedFolder)
    }

    private func datesWithTasks() -> [Date] {
        let uniqueDates = Set(tasks.map { Calendar.current.startOfDay(for: $0.date) })
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
    static var previews: some View {
        TasksByDateView()
            .previewLayout(.sizeThatFits)
            .environmentObject(DataManager())
    }
}
