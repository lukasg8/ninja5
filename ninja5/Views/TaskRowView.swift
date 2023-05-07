import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var manager: DataManager
    @Binding var task: Task
    @State private var showAlert = false

    func colorFromName(_ colorName: String) -> Color {
        switch colorName {
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "red":
            return Color.red
        default:
            return Color.gray
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)

            VStack(alignment: .leading) {
                HStack {
                    Text(task.title)
                        .strikethrough(task.completed)
                        .foregroundColor(task.completed ? .gray : .primary)
                        .font(.system(size: 18, weight: .semibold))

                    Text(task.folder?.name ?? "No Folder")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(colorFromName(task.folder?.colorName ?? "gray"))
                        .cornerRadius(4)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        task.completed.toggle()
                        manager.updateTask(updatedTask: task)
                    }) {
                        Image(systemName: task.completed ? "checkmark.circle" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(task.completed ? .blue : .gray)
                    }
                    .padding(.trailing, 12)
                }

                HStack {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Button(action: {
                        showAlert.toggle()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Delete Task"),
                              message: Text("Are you sure you want to delete this task?"),
                              primaryButton: .destructive(Text("Delete")) {
                                  if let index = manager.tasks.firstIndex(where: { $0.id == task.id }) {
                                      manager.deleteTask(for: index)
                                  }
                              },
                              secondaryButton: .cancel())
                    }
                    .padding(.trailing, 12)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 70)
        .padding(.horizontal, 8)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: .constant(Task(id: UUID(), title: "Sample Task", description: "Description for task", date: Date(), folder: Folder(id: UUID(), name: "Sample Folder", colorName: "blue", notes: [], tasks: [], subfolders: []), completed: false)))
            .previewLayout(.sizeThatFits)
            .environmentObject(DataManager())
    }
}
