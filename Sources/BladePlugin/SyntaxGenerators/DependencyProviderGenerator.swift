import Foundation
import SwiftSyntax

enum DependencyProviderGenerator {
    static func generate(
        visibility: Visibility,
        binding: Binding,
        moduleType: String?
    ) -> DeclSyntax {
        let tTypeAliasDecl = TypeAliasDeclSyntax(
            visibility: visibility,
            alias: "T",
            type: binding.returnType
        )

        let variableDecls = switch binding.scope {
        case .singleton:
            [
                VariableDeclSyntax.privateLet(
                    name: "instance",
                    type: "T"
                )
            ]
        case .unscoped:
            binding.parameters.map { parameter in
                VariableDeclSyntax.privateLet(
                    name: parameter.name,
                    type: "any DependencyProvider<\(parameter.type)>"
                )
            }
        }

        let initDecl = InitializerDeclSyntax.providerInit(
            visibility: visibility,
            binding: binding,
            moduleType: moduleType
        )

        let getFunctionDecl = FunctionDeclSyntax.providerGet(
            visibility: visibility,
            binding: binding,
            moduleType: moduleType
        )

        return DeclSyntax(
            ClassDeclSyntax(
                visibility: visibility,
                name: binding.providerName,
                inheritedTypes: ["DependencyProvider"],
                typeAliasDecls: [tTypeAliasDecl],
                variableDecls: variableDecls,
                initDecls: [initDecl],
                functionDecls: [getFunctionDecl]
            )
        )
    }
}

private extension InitializerDeclSyntax {
    static func providerInit(
        visibility: Visibility,
        binding: Binding,
        moduleType: String?
    ) -> InitializerDeclSyntax {
        InitializerDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility),
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
            body: CodeBlockSyntax.providerInitBody(
                binding: binding,
                moduleType: moduleType
            )
        )
    }
}

private extension CodeBlockSyntax {
    static func providerInitBody(
        binding: Binding,
        moduleType: String?
    ) -> CodeBlockSyntax {
        switch binding.scope {
        case .singleton:
            CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    [
                        .expr("self.instance = \(binding.toInstanceInitializerExpression(moduleType: moduleType))")
                    ]
                )
            )
        case .unscoped:
            CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    binding.parameters.map { parameter in
                        .expr("self.\(parameter.name) = \(parameter.toDependencyResolutionExpression())")
                    }
                )
            )
        }
    }
}

private extension FunctionDeclSyntax {
    static func providerGet(
        visibility: Visibility,
        binding: Binding,
        moduleType: String?
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility),
            name: TokenSyntax(stringLiteral: "get"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax()),
                returnClause: ReturnClauseSyntax(type: TypeSyntax(stringLiteral: "T"))
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    [
                        .expr(
                            {
                                switch binding.scope {
                                case .singleton: "instance"
                                case .unscoped: binding.toGetFunctionExpression(moduleType: moduleType)
                                }
                            }()
                        )
                    ]
                )
            )
        )
    }
}

private extension Binding {
    func toGetFunctionExpression(moduleType: String?) -> String {
        toExpression(
            moduleType: moduleType,
            parameterValueExpression: { parameter in
                switch parameter.variant {
                case .instance: "\(parameter.name).get()"
                case .lazy: "Lazy { [\(parameter.name)] in \(parameter.name).get() }"
                }
            }
        )
    }

    func toInstanceInitializerExpression(moduleType: String?) -> String {
        toExpression(
            moduleType: moduleType,
            parameterValueExpression: { parameter in
                switch parameter.variant {
                case .instance: "\(parameter.toDependencyResolutionExpression()).get()"
                case .lazy: "Lazy { \(parameter.toDependencyResolutionExpression()).get() }"
                }
            }
        )
    }

    private func toExpression(
        moduleType: String?,
        parameterValueExpression: (BindingParameter) -> String
    ) -> String {
        let base = moduleType.flatMap { "\($0).\(functionName)" } ?? functionName

        let arguments = parameters
            .map { "\($0.name): \(parameterValueExpression($0))" }
            .joined(separator: ",\n")

        return arguments.isEmpty
            ? "\(base)()"
            : "\(base)(\n\(arguments)\n)"
    }
}

private extension BindingParameter {
    func toDependencyResolutionExpression() -> String {
        if let name = attributes.named?.name {
            "resolver.resolve(type: \(type).self, name: \(name))"
        } else {
            "resolver.resolve(type: \(type).self)"
        }
    }
}
