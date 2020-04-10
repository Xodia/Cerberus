import Files
import Stencil
import PathKit
import Foundation
import CerberusCore

public struct Cerberus {

    let environment: StencilEnvironment

    public typealias StencilTemplateName = String
    public typealias StencilTemplate = (StencilTemplateName, (Module, Submodule, Language) -> (fileName: String, context: [String: Any]))
    private let templates: [StencilTemplate]

    public init(environment: Environment, templates: [StencilTemplate]) {
        self.templates = templates
        self.environment = StencilEnvironment(environment: environment)
    }

    public func export(outputDirectory: Folder, module: Module) {
        if let subfolder = try? outputDirectory.subfolder(at: "generated.cerberus") {
            try? subfolder.delete()
        }

        guard let genFolder = try? outputDirectory.createSubfolder(at: "generated.cerberus") else {
            print("Couldn't created generated.cerberus on the directory output: \(outputDirectory.path)")
            return
        }

        module.submodules.forEach { (submodule) in
            generate(genFolder, module: module, submodule: submodule)
        }
    }
}

private extension Cerberus {

    func generate(_ folder: Folder, module: Module, submodule: Submodule) {
        submodule.language.forEach { (language) in
            templates.forEach { (template, output) in
                let context = output(module, submodule, language)
                let content = environment.renderTemplate(name: template, context: context.context)
                FileGenerator.createFile(at: folder.path + language.identifier, fileName: context.fileName, content: content)
            }
        }
    }
}
