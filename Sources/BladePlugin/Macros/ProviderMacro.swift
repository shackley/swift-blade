import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ProviderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if declaration.is(FunctionDeclSyntax.self) {
            return []
        }

        guard let initializerDecl = declaration.as(InitializerDeclSyntax.self) else {
            context.diagnose(
                node: node,
                message: .invalidProviderPeer
            )
            return []
        }

        let attribute = ProviderAttributeParser.parse(
            attribute: node,
            context: context
        )

        if attribute.returnType != nil {
            context.diagnose(
                node: node,
                message: .unnecessaryProviderFunctionReturnType
            )
        }

        let providerContext = ProviderContextParser.parse(
            lexicalContext: context.lexicalContext
        )

        guard let returnType = providerContext.type else {
            context.diagnose(
                node: node,
                message: .unknownProviderReturnType
            )
            return []
        }

        guard attribute.named == nil else {
            context.diagnose(
                node: node,
                message: .namedProviderNotPermitted
            )
            return []
        }

        let visibility = VisibilityParser.parse(modifierList: initializerDecl.modifiers)

        let initializerBinding = InitializerBindingParser.parse(
            initializerDecl: initializerDecl,
            scope: attribute.scope,
            returnType: returnType,
            context: context
        )

        return [
            DependencyProviderGenerator.generate(
                visibility: visibility,
                binding: initializerBinding,
                moduleType: nil
            )
        ]
    }
}
