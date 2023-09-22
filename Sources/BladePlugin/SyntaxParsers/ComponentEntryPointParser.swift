import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

enum ComponentEntryPointParser {
    static func parse(
        functionDecl: FunctionDeclSyntax,
        context: some MacroExpansionContext
    ) -> ComponentEntryPoint? {
        guard functionDecl.signature.parameterClause.parameters.isEmpty else {
            context.diagnose(
                node: functionDecl,
                message: .invalidEntryPointFunctionParameters
            )
            return nil
        }

        let name = functionDecl.name.text

        guard let returnType = functionDecl.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text else {
            context.diagnose(
                node: functionDecl,
                message: .invalidEntryPointFunctionReturnType
            )
            return nil
        }

        return ComponentEntryPoint(
            name: name,
            returnType: returnType
        )
    }
}
