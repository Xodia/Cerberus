//
//  File.swift
//  
//
//  Created by Morgan Collino on 4/10/20.
//

import Foundation
import CerberusCore

struct Contexts {

    struct Subkey: Codable {
        let name: String
        let isPascal: Bool
    }

    static func codeGenerationContext(copies: [Copy], arrays: [CopyArray], moduleName: String, submoduleName: String, fileName: String) -> [String: Any] {
        let arrays = arrays.compactMap { $0.asDictionary() }

        let keys = Array(Set(copies.compactMap { $0.key }))
        let subkeys = Array(Set(copies.compactMap { $0.value.parameters?.compactMap({ $0.name }) }.flatMap({ $0 }))).compactMap({
            Subkey(name: $0, isPascal:  $0.contains("_")) })
        let singles = copies.filter({ $0.isSingle }).compactMap { $0.asDictionary() }
        let formats = copies.filter({ $0.isPlural }).compactMap { $0.asDictionary() }

        return [
            "copy": singles,
            "formats": formats,
            "array": arrays,
            "module_name": moduleName,
            "submodule_name": submoduleName,
            "file_name": fileName,
            "keys": keys,
            "subkeys": subkeys
        ]
    }

    static func androidXMLContext(copies: [Copy], formats: [Format], arrays: [CopyArray], moduleName: String, submoduleName: String, fileName: String) -> [String: Any] {
        let filtered = filterAndroid(copies: copies, formats: formats)

        let copies = filtered.copies.compactMap { $0.asDictionary() }
        let arrays = arrays.compactMap { $0.asDictionary() }
        let formats = filtered.formats.compactMap({ $0.asDictionary() })

        return [
            "copy": copies,
            "formats": formats,
            "array": arrays,
            "module_name": moduleName,
            "submodule_name": submoduleName,
            "file_name": fileName
        ]
    }

    static func filterAndroid(copies: [Copy], formats: [Format]) -> (copies: [Copy], formats: [Format]) {
        var mutableCopies = copies
        var mutableFormats = formats

        mutableFormats = formats.compactMap { (format) -> Format in
            var mutableVariants = format.variants
            if let zeroIndex = format.variants.firstIndex(where: { (variant) -> Bool in
                return variant.qualifier == .zero
            }) {
                let zeroVariant = format.variants[zeroIndex]
                let zeroCopy = Copy(key: format.parent + "_" + format.key + "_" + zeroVariant.qualifier.rawValue, value: Value(value: zeroVariant.variant, parameters: nil))
                mutableCopies.append(zeroCopy)
                mutableVariants.remove(at: zeroIndex)
            }
            return Format(parent: format.parent, parentFormat: format.parentFormat, key: format.key, type: format.type, variants: mutableVariants)
        }
        return (mutableCopies, mutableFormats)
    }

    static func stringsContext(singles: [Copy], formats: [Copy], moduleName: String, submoduleName: String, fileName: String) -> [String: Any] {
        let singles = singles.compactMap { $0.asDictionary() }
        let formats = formats.compactMap({ $0.asDictionary() })

        return [
            "singles": singles,
            "formats": formats,
            "module_name": moduleName,
            "submodule_name": submoduleName,
            "file_name": fileName
        ]
    }

    static func stringsDictContext(formats: [Format], moduleName: String, submoduleName: String, fileName: String) -> [String: Any] {
        let formats = formats.compactMap({ $0.asDictionary() })

        return [
            "formats": formats,
            "module_name": moduleName,
            "submodule_name": submoduleName,
            "file_name": fileName,
        ]
    }

}
