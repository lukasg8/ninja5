//
//  CanvasViewControllerRepresentable.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import SwiftUI
import PencilKit

struct CanvasViewControllerRepresentable: UIViewControllerRepresentable {
        
    @Binding var canvasView: PKCanvasView
//    @Binding var toolpicker: PKToolPicker
    
    // inits to data for specific Note
    var manager:DataManager
    var id:UUID
    
    func makeUIViewController(context: Context) -> some CanvasViewController {
        
        let canvasViewController = CanvasViewController()
        
        // initialising view controller
        canvasView.frame = UIScreen.main.bounds
        canvasViewController.canvasView = canvasView
        
        // initialising data for PKCanvasView and function to save data changes to CoreData
        canvasViewController.drawingData = manager.getCanvasData(for: id)
        canvasViewController.drawingChanged = { data in
            manager.updateCanvasData(canvasData: data, for: id)
        }
        
        return canvasViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.drawingData = manager.getCanvasData(for:id)
    }
    
}
