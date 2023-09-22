import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum InitializerBindingParser {
    static func parse(
        initializerDecl: InitializerDeclSyntax,
        scope: Scope,
        returnType: String,
        context: some MacroExpansionContext
    ) -> InitializerBinding {
        let parameters = initializerDecl.signature.parameterClause.parameters.compactMap { parameter in
            BindingParameterParser.parse(parameter: parameter, context: context)
        }

        return InitializerBinding(
            scope: scope,
            parameters: parameters,
            returnType: returnType
        )
    }
}
