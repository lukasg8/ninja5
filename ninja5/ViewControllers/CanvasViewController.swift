//
//  CanvasViewController.swift
//  ninja5
//
//  Created by Lukas on 5/3/23.
//

import UIKit
import PencilKit

class CanvasViewController: UIViewController {
    
    // inits
    var canvasView = PKCanvasView()
    lazy var toolpicker: PKToolPicker = {
        let toolpicker = PKToolPicker()
        toolpicker.addObserver(self)
        return toolpicker
    }()
    
    // parameters
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = { _ in }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(canvasView)
        
        // Set up canvasView
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: UIColor.black, width: 10)
        canvasView.delegate = self
        canvasView.becomeFirstResponder()
        
        // Set up toolpicker
        toolpicker.setVisible(true, forFirstResponder: canvasView)
        toolpicker.addObserver(canvasView)
        
        // Adding button to toggle tool
        let toolButton = UIButton(type: .system)
        toolButton.setTitle("Switch Tool", for: .normal)
//        toolButton.addTarget(self, action: #selector(), for: .touchUpInside)

        
        // add drawing data to canvasView
        if let drawing = try? PKDrawing(data: drawingData) {
            canvasView.drawing = drawing
        }
        
    }
    
    @objc func switchTooltoHighlighter(_ sender: UIButton) {
                
        canvasView.tool = PKInkingTool(.marker, color: UIColor.black, width: 10)
        
    }
    
    
    
    // For better latency
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
}

extension CanvasViewController: PKToolPickerObserver, PKCanvasViewDelegate {
    
    // Saving canvasData to CoreData when canvasData changes
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
    
}
