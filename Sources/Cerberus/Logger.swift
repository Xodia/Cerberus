//
//  File.swift
//  
//
//  Created by Morgan Collino on 5/14/20.
//

import Foundation
import Logging

struct CerberusLogger {

    static let logger = Logger(label: "com.example.Cerberus")

    static func log(_ info: String) {
        logger.info("\(info)")
    }
}
