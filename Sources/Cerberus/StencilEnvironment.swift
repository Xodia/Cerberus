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

    init() {
        let ext = StencilExtension.ext
        let loader = FileSystemLoader(paths: [Path(Bundle.main.bundlePath)])
        self.environment = Environment(loader: loader, extensions: [ext])
    }

    func renderTemplate(name: String, context: [String: Any]?) -> String {
        do {
            let output = try environment.renderTemplate(name: name, context: context ?? [:])
            return output
        } catch {
            print("Could not render template \(name) with given context: \(String(describing: context)) err: \(error)")
            return ""
        }
    }
}
