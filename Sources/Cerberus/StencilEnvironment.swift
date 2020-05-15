//
//  StencilEnvironment.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation
import Stencil
import PathKit


struct StencilEnvironment {

    let environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func renderTemplate(name: String, context: [String: Any]?) -> String {
        do {
            let output = try environment.renderTemplate(name: name, context: context ?? [:])
            return output
        } catch {
            CerberusLogger.log("Could not render template \(name) with given context: \(String(describing: context)) err: \(error)")
            return ""
        }
    }
}
