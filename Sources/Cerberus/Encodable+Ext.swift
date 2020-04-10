//
//  File.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation

extension Encodable {

    func asDictionary() -> [String: Any] {
        do {
            guard let data = try? JSONEncoder().encode(self),
                let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
                    print("Couldn't encode \(self) to JSON dictionary.")
                    return [:]
            }
            return dictionary
        } catch {
            return [:]
        }
    }
}
