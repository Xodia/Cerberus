//
//  ParameterType.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation

public enum ParameterType: String, Codable {
    case integer
    case float
    case string
}

extension ParameterType {

    public var iOS: String {
        switch self {
        case .integer:
            return "d"
        case .float:
            return ".2f"
        case .string:
            return "@"
        }
    }

    public var iOSType: String {
        switch self {
        case .integer:
            return "Int"
        case .float:
            return "Double"
        case .string:
            return "String"
        }
    }

    public var android: String {
        switch self {
        case .integer:
            return "d"
        case .float:
            return "f"
        case .string:
            return "s"
        }
    }
}
