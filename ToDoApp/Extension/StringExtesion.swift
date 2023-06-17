//
//  StringExtesion.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 16.06.2023.
//

import Foundation

extension String {
    
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\{},./?<>").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        return encodedString
    }
    
}
