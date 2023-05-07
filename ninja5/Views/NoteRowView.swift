import SwiftUI

struct NoteRowView: View {
    @EnvironmentObject var manager: DataManager
    @Binding var note: Note
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

            HStack {
                Image(systemName: "note.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .foregroundColor(.gray)

                VStack(alignment: .leading) {
                    HStack {
                        Text(note.title)
                            .font(.system(size: 18, weight: .semibold))

                        Text(note.folder?.name ?? "No Folder")
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(colorFromName(note.folder?.colorName ?? "gray"))
                            .cornerRadius(4)
                            .foregroundColor(.white)

                        Spacer()
                    }

                    HStack {
                        Text("Note description 1")
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
                            Alert(title: Text("Delete Note"),
                                  message: Text("Are you sure you want to delete this note?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                      if let index = manager.notes.firstIndex(where: { $0.id == note.id }) {
                                          manager.deleteNote(for: index)
                                      }
                                  },
                                  secondaryButton: .cancel())
                        }
                        .padding(.trailing, 12)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 8)
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(note: .constant(Note(id: UUID(), canvasData: Data(), title: "Sample Note", selected: false, folder: Folder(id: UUID(), name: "Sample Folder", colorName: "blue", notes: [], tasks: [], subfolders: []))))
            .previewLayout(.sizeThatFits)
            .environmentObject(DataManager())
    }
}
