//
//  File 2.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func camelCased() -> String {
        return StencilExtension.camelCase(string: self)
    }
}
