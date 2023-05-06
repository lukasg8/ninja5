//
//  DrawingView.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    
    @State private var canvasView = PKCanvasView()
    
    var manager: DataManager
    var id:UUID
    
    var body: some View {
        CanvasViewControllerRepresentable(canvasView: $canvasView, manager: manager, id: id)
            .padding(0)
            .background(Color.cyan)
            .navigationBarTitle("Note 1")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Clear note
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.canvasView.drawing = PKDrawing()
                    }, label: {
                        Image(systemName: "trash")
                    })
                    
                }
            }
    }
}

