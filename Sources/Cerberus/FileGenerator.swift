//
//  File.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation
import Files

struct FileGenerator {

    static func createFile(at path: String, fileName: String, content: String) {
        createDirectoryAtPathIfNotExisting(path: path)

        guard let data = content.data(using: .utf8) else {
            print("error(message: Could not transform content \(content) to UTF8.")
            return
        }

        let filePath = [path, "/", fileName].joined()
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        print("successFileCreation(name: \(fileName), path: \(path)")
    }

    static func createDirectoryAtPathIfNotExisting(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            print("directoryCreation(path: \(path))")
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
    }

}
