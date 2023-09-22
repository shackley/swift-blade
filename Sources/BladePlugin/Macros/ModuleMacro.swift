import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

public struct ModuleMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(
                node: node,
                message: .invalidModuleType
            )
            return []
        }

        let attribute = ModuleAttributeParser.parse(attribute: node, context: context)

        let visibility = VisibilityParser.parse(modifierList: enumDecl.modifiers)

        let moduleType = enumDecl.name.text

        let providerFunctionBindings = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .enumerated()
            .compactMap { index, functionDecl in
                ProviderFunctionBindingParser.parse(
                    functionDecl: functionDecl,
                    index: index,
                    context: context
                )
            }

        return [
            ModuleGenerator.generate(
                attribute: attribute,
                visibility: visibility,
                moduleType: moduleType,
                providerFunctionBindings: providerFunctionBindings
            )
        ]
    }
}
