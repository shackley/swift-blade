import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct ComponentMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let protocolDecl = declaration.as(ProtocolDeclSyntax.self) else {
            context.diagnose(
                node: node,
                message: .invalidComponentType
            )
            return []
        }

        let attribute = ComponentAttributeParser.parse(attribute: node, context: context)

        let visibility = VisibilityParser.parse(modifierList: protocolDecl.modifiers)

        let componentType = protocolDecl.name.text

        let initializerDecls = protocolDecl.memberBlock.members
            .compactMap { $0.decl.as(InitializerDeclSyntax.self) }

        guard initializerDecls.count <= 1 else {
            context.diagnose(
                node: node,
                message: .invalidComponentInitializerCount
            )
            return []
        }

        let componentParameters = initializerDecls.first
            .flatMap { ComponentInitializerParser.parse(initializerDecl: $0, context: context).parameters }
            ?? []

        let componentEntryPoints = protocolDecl.memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .compactMap { ComponentEntryPointParser.parse(functionDecl: $0, context: context) }

        return [
            ComponentGenerator.generate(
                attribute: attribute,
                visibility: visibility,
                componentType: componentType,
                componentParameters: componentParameters,
                componentEntryPoints: componentEntryPoints
            )
        ]
    }
}
