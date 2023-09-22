import SwiftSyntax
import Foundation

extension VariableDeclSyntax {
    static func publicLet(name: String, type: String) -> VariableDeclSyntax {
        VariableDeclSyntax.variable(
            modifiers: [.public],
            specifier: .let,
            name: name,
            type: type,
            initializer: nil
        )
    }

    static func privateLet(name: String, type: String) -> VariableDeclSyntax {
        VariableDeclSyntax.variable(
            modifiers: [.private],
            specifier: .let,
            name: name,
            type: type,
            initializer: nil
        )
    }

    static func privateLazyVar(name: String, initializer: String) -> VariableDeclSyntax {
        VariableDeclSyntax.variable(
            modifiers: [.private, .lazy],
            specifier: .var,
            name: name,
            type: nil,
            initializer: initializer
        )
    }

    private static func variable(
        modifiers: [Keyword],
        specifier: Keyword,
        name: String,
        type: String?,
        initializer: String?
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: DeclModifierListSyntax(
                modifiers.map { DeclModifierSyntax(name: .keyword($0)) }
            ),
            bindingSpecifier: .keyword(specifier),
            bindings: PatternBindingListSyntax(
                [
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: TokenSyntax(stringLiteral: name)),
                        typeAnnotation: type.flatMap {
                            TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: $0))
                        },
                        initializer: initializer.flatMap {
                            InitializerClauseSyntax(value: ExprSyntax(stringLiteral: $0))
                        }
                    )
                ]
            )
        )
    }
}
