import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum ComponentInitializerParser {
    static func parse(
        initializerDecl: InitializerDeclSyntax,
        context: some MacroExpansionContext
    ) -> ComponentInitializer {
        let parameters = initializerDecl.signature.parameterClause.parameters.compactMap { parameter in
            BindingParameterParser.parse(parameter: parameter, context: context)
        }

        return ComponentInitializer(
            parameters: parameters
        )
    }
}
