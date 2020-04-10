import Files
import Stencil
import PathKit
import Foundation
import CerberusCore

public struct Cerberus {

    let environment = StencilEnvironment()

    public init() {
        
    }

    public enum ExportType: String {
        case iOS = "ios"
        case android
    }

    public func export(type: ExportType, outputDirectory: Folder, module: Module) {
        if let subfolder = try? outputDirectory.subfolder(at: "generated.cerberus") {
            try? subfolder.delete()
        }

        guard let genFolder = try? outputDirectory.createSubfolder(at: "generated.cerberus") else {
            print("Couldn't created generated.cerberus on the directory output: \(outputDirectory.path)")
            return
        }

        module.submodules.forEach { (submodule) in
            switch type {
            case .iOS:
                ios(genFolder, module: module, submodule: submodule)
            case .android:
                android(genFolder, parentName: module.name, submodule: submodule)
            }
        }
    }
}

private extension Cerberus {

    func ios(_ folder: Folder, module: Module, submodule: Submodule) {
        submodule.language.forEach { (language) in
            print("\(folder.path)/\(language.identifier).lproj/\(module.name)\(submodule.name).strings")
            iOSXMLStrings(stencilEnvironment: environment).format(module: module, submodule: submodule, language: language, outputFolder: folder)
        }
    }

    func android(_ folder: Folder, parentName: String, submodule: Submodule) {
        submodule.language.forEach { (language) in
            print("\(folder.path)/resources-\(language.identifier)/\(parentName)\(submodule.name).xml")
        }
    }
}
