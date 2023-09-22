import Foundation
import SwiftSyntax

enum ModuleGenerator {
    static func generate(
        attribute: ModuleAttribute,
        visibility: Visibility,
        moduleType: String,
        providerFunctionBindings: [ProviderFunctionBinding]
    ) -> DeclSyntax {
        let providerClassDecls = providerFunctionBindings.map { providerFunctionBinding in
            DependencyProviderGenerator.generate(
                visibility: visibility,
                binding: providerFunctionBinding,
                moduleType: moduleType
            )
        }

        let registerFunctionDecl = FunctionDeclSyntax.register(
            visibility: visibility,
            providerFunctionBindings: providerFunctionBindings,
            moduleType: moduleType,
            providesTypes: attribute.providesTypes,
            submoduleTypes: attribute.submoduleTypes
        )

        let deregisterFunctionDecl = FunctionDeclSyntax.deregister(
            visibility: visibility,
            providerFunctionBindings: providerFunctionBindings,
            moduleType: moduleType,
            providesTypes: attribute.providesTypes,
            submoduleTypes: attribute.submoduleTypes
        )

        return DeclSyntax(
            EnumDeclSyntax(
                modifiers: DeclModifierListSyntax(visibility: visibility),
                name: TokenSyntax(stringLiteral: "_$Blade\(moduleType)"),
                memberBlock: MemberBlockSyntax(
                    members: MemberBlockItemListSyntax(
                        providerClassDecls.map { MemberBlockItemSyntax(decl: $0) } +
                        [
                            MemberBlockItemSyntax(decl: registerFunctionDecl),
                            MemberBlockItemSyntax(decl: deregisterFunctionDecl)
                        ]
                    )
                )
            )
        )
    }
}

private extension FunctionDeclSyntax {
    static func register(
        visibility: Visibility,
        providerFunctionBindings: [ProviderFunctionBinding],
        moduleType: String,
        providesTypes: [String],
        submoduleTypes: [String]
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility) +
                [ DeclModifierSyntax(name: .keyword(.static)) ],
            name: "register",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        [
                            FunctionParameterSyntax(
                                name: "resolver",
                                type: "DependencyProviderResolver"
                            )
                        ]
                    )
                )
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    providerFunctionBindings.map { binding in
                        if let name = binding.named {
                            .expr("resolver.register(provider: \(binding.providerName)(resolver: resolver), name: \(name))")
                        } else {
                            .expr("resolver.register(provider: \(binding.providerName)(resolver: resolver))")
                        }
                    } + providesTypes.map { type in
                        .expr("resolver.register(provider: \(type)._$BladeDependencyProvider(resolver: resolver))")
                    } + submoduleTypes.map { type in
                        .expr("_$Blade\(type).register(resolver: resolver)")
                    }
                )
            )
        )
    }

    static func deregister(
        visibility: Visibility,
        providerFunctionBindings: [ProviderFunctionBinding],
        moduleType: String,
        providesTypes: [String],
        submoduleTypes: [String]
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility) +
                [ DeclModifierSyntax(name: .keyword(.static)) ],
            name: "deregister",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        [
                            FunctionParameterSyntax(
                                name: "resolver",
                                type: "DependencyProviderResolver"
                            )
                        ]
                    )
                )
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    providerFunctionBindings.map { binding in
                        if let name = binding.named {
                            .expr("resolver.deregister(type: \(binding.returnType).self, name: \(name))")
                        } else {
                            .expr("resolver.deregister(type: \(binding.returnType).self)")
                        }
                    } + providesTypes.map { type in
                        .expr("resolver.deregister(type: \(type).self)")
                    } + submoduleTypes.map { type in
                        .expr("_$Blade\(type).deregister(resolver: resolver)")
                    }
                )
            )
        )
    }
}
