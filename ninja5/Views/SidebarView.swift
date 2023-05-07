//
//  SidebarView.swift
//  ninja5
//
//  Created by Lukas on 5/6/23.
//

import SwiftUI

struct SidebarView: View {
    
    @State private var courses: [Folder] = [
        Folder(
            id: UUID(),
            name: "CMSC 143",
            colorName: "blue",
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "MATH 153",
            colorName: "green",
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "PHYS 131",
            colorName: "purple",
            notes: [],
            tasks: [],
            subfolders: []
        ),
        Folder(
            id: UUID(),
            name: "PHIL 272",
            colorName: "red",
            notes: [],
            tasks: [],
            subfolders: []
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(courses, id: \.id) { course in
                    NavigationLink(destination: Text("Home view for \(course.name)")) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(course.color.opacity(0.7))
                                .frame(maxWidth:.infinity)
                                .frame(height:55)
                            HStack {
                                Text(course.name)
                                    .foregroundColor(.white)
                                    .font(.system(size:30))
                                    .bold()
                                    .padding(.horizontal,10)
                                Spacer()
                            }
                        }
                    }
                    .padding(.bottom, 2)
                }
                Spacer()
            }
            .padding()
        }
    }
}
