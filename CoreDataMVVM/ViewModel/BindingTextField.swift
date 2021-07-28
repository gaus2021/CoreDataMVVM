//
//  BindingTextField.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation
import UIKit

//MARK:- Text Field binding class for two way binding
class BindingTextField: UITextField {
    
    var textChanged : (String) -> () = { _ in}
    
    func bind(callback: @escaping (String) -> ()) {
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.textChanged(textField.text ?? "")
    }
}
