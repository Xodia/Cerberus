//
//  File 2.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation
import CerberusCore
import Files

struct iOSXMLStrings {

    let stencilEnvironment: StencilEnvironment

    init(stencilEnvironment: StencilEnvironment) {
        self.stencilEnvironment = stencilEnvironment
    }

    func format(module: Module, submodule: Submodule, language: Language, outputFolder: Folder) {
        let filename = [module.name, submodule.name].compactMap({ $0.capitalizingFirstLetter() }).joined()
        let fileName = "\(filename).strings"
        let singles = language.copy.filter { $0.isSingle }
        let plurals = language.copy.filter({ $0.isPlural || $0.isInterpolated }).compactMap { formatCopy(copy: $0) }
        let context = Contexts.stringsContext(singles: singles, formats: plurals, moduleName: module.name, submoduleName: submodule.name, fileName: fileName)
        let content = stencilEnvironment.renderTemplate(name: StencilTemplate.strings.rawValue, context: context)
        FileGenerator.createFile(at: outputFolder.path + language.identifier, fileName: fileName, content: content)
    }
}

extension iOSXMLStrings {

    func formatCopy(copy: Copy) -> Copy {
        let formattedCopy = format(copy)
        let value = Value(value: formattedCopy, parameters: copy.value.parameters)
        return Copy(key: copy.key, value: value)
    }

    private func format(_ copy: Copy) -> String {
        var value = copy.value.value
        copy.value.parameters?.enumerated().forEach({ (index, parameter) in
            value = value.replacingOccurrences(of: "__\(parameter.name)__", with: "%\(index + 1)$\(ParameterType.string.iOS)")
        })
        return value
    }
}
