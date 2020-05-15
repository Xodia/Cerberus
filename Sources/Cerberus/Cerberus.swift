import Files
import Stencil
import PathKit
import Foundation
import CerberusCore

public struct Cerberus {

    let environment: StencilEnvironment

    public enum GenerationType {
        case eachLanguage(extension: String? = nil)
        case once
    }

    public typealias StencilTemplateName = String
    public typealias StencilTemplate = ((name: StencilTemplateName, generationType: GenerationType), (Module, Submodule, Language) -> (fileName: String, context: [String: Any]))
    private let templates: [StencilTemplate]

    public init(environment: Environment, templates: [StencilTemplate]) {
        self.templates = templates
        self.environment = StencilEnvironment(environment: environment)
    }

    public func export(outputDirectory: Folder, module: Module, subfolderPath: String? = "generated.cerberus") {
        if let subfolderPath = subfolderPath, let subfolder = try? outputDirectory.subfolder(at: subfolderPath) {
            try? subfolder.delete()
        }

        guard let genFolder = try? outputDirectory.createSubfolder(at: "generated.cerberus") else {
            CerberusLogger.log("Couldn't created generated.cerberus on the directory output: \(outputDirectory.path)")
            return
        }

        module.submodules.forEach { (submodule) in
            generate(genFolder, module: module, submodule: submodule)
        }
    }
}

private extension Cerberus {

    func generate(_ folder: Folder, module: Module, submodule: Submodule) {
        templates.forEach { (template, output) in
            switch template.generationType {
            case .eachLanguage(let ext):
                submodule.language.forEach { (language) in
                    let context = output(module, submodule, language)
                    let content = environment.renderTemplate(name: template.name, context: context.context)
                    let path: String = {
                        guard let ext = ext else {
                            return folder.path + language.identifier
                        }
                        return folder.path + language.identifier + ext
                    }()
                    FileGenerator.createFile(at: path, fileName: context.fileName, content: content)
                }
            case .once:
                guard let firstLanguage = submodule.language.first else {
                    CerberusLogger.log("Misformated submodule \(submodule)")
                    return
                }
                let context = output(module, submodule, firstLanguage)
                let content = environment.renderTemplate(name: template.name, context: context.context)
                FileGenerator.createFile(at: folder.path, fileName: context.fileName, content: content)
            }
        }
    }
}
