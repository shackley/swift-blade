import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum ProviderContextParser {
    static func parse(
        lexicalContext: [Syntax]
    ) -> ProviderContext {
        let type: String? = {
            for syntax in lexicalContext {
                if let classDecl = syntax.as(ClassDeclSyntax.self) {
                    return classDecl.name.text
                } else if let structDecl = syntax.as(StructDeclSyntax.self) {
                    return structDecl.name.text
                } else if let enumDecl = syntax.as(EnumDeclSyntax.self) {
                    return enumDecl.name.text
                }
            }
            return nil
        }()

        return ProviderContext(
            type: type
        )
    }
}
