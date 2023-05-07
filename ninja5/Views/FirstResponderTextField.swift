//
//  FirstResponderTextField.swift
//  ninja5
//
//  Created by Lukas on 5/7/23.
//

import Foundation
import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
    
    @Binding var text:String
    let placeholder:String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        var becameFirstResponder = false
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textfield = UITextField()
        textfield.delegate = context.coordinator
        textfield.placeholder = placeholder
        return textfield
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
    
    
}
