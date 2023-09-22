import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

enum ProviderFunctionBindingParser {
    static func parse(
        functionDecl: FunctionDeclSyntax,
        index: Int,
        context: some MacroExpansionContext
    ) -> ProviderFunctionBinding? {
        let attributes = FunctionAttributeListParser.parse(
            attributeList: functionDecl.attributes,
            context: context
        )

        guard let attribute = attributes.provider else {
            return nil
        }

        if attribute.returnType != nil {
            context.diagnose(
                node: functionDecl.attributes,
                message: .unnecessaryProviderFunctionReturnType
            )
        }

        let modifiers = functionDecl.modifiers.map { $0.name.text }.toSet()

        guard modifiers.contains("static") else {
            context.diagnose(
                node: functionDecl,
                message: .invalidProviderFunctionModifier
            )
            return nil
        }

        let functionName = functionDecl.name.text

        let parameters = functionDecl.signature.parameterClause.parameters.compactMap { parameter in
            BindingParameterParser.parse(parameter: parameter, context: context)
        }

        guard let returnType = functionDecl.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.description.trimmed() else {
            context.diagnose(
                node: functionDecl,
                message: .missingProviderFunctionReturnType
            )
            return nil
        }

        return ProviderFunctionBinding(
            scope: attribute.scope,
            named: attribute.named,
            functionName: functionName,
            parameters: parameters,
            returnType: returnType,
            index: index
        )
    }
}
