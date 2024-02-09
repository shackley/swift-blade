import Foundation
import SwiftSyntax

enum ComponentGenerator {
    static func generate(
        attribute: ComponentAttribute,
        visibility: Visibility,
        componentType: String,
        componentParameters: [BindingParameter],
        componentEntryPoints: [ComponentEntryPoint]
    ) -> DeclSyntax {
        let resolverVariableDecl = VariableDeclSyntax.privateLet(
            name: "resolver",
            type: "DependencyProviderResolver"
        )

        let providerVariableDecls = componentEntryPoints.map { entryPoint in
            VariableDeclSyntax.privateLet(
                name: "\(entryPoint.returnType.toCamelCase())Provider",
                type: "any DependencyProvider<\(entryPoint.returnType)>"
            )
        }

        let initDecl = InitializerDeclSyntax.componentInit(
            visibility: visibility,
            componentParameters: componentParameters,
            moduleTypes: attribute.moduleTypes,
            componentEntryPoints: componentEntryPoints
        )

        let deinitDecl = DeinitializerDeclSyntax.componentDeinit(
            moduleTypes: attribute.moduleTypes
        )

        let entryPointFunctionDecls = componentEntryPoints.map { entryPoint in
            FunctionDeclSyntax.componentEntryPoint(
                visibility: visibility,
                entryPoint: entryPoint
            )
        }

        return DeclSyntax(
            ClassDeclSyntax(
                visibility: visibility,
                name: "Blade\(componentType)",
                inheritedTypes: [componentType],
                variableDecls: [resolverVariableDecl] + providerVariableDecls,
                initDecls: [initDecl],
                deinitDecls: [deinitDecl],
                functionDecls: entryPointFunctionDecls
            )
        )
    }
}

private extension InitializerDeclSyntax {
    static func componentInit(
        visibility: Visibility,
        componentParameters: [BindingParameter],
        moduleTypes: [String],
        componentEntryPoints: [ComponentEntryPoint]
    ) -> InitializerDeclSyntax {
        InitializerDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility) +
                [ DeclModifierSyntax(name: .keyword(.required)) ],
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        componentParameters.enumerated().map { index, parameter in
                            FunctionParameterSyntax(
                                name: parameter.name,
                                type: parameter.type,
                                trailingComma: index < (componentParameters.count - 1)
                            )
                        }
                    )
                )
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    [
                        .expr("self.resolver = DependencyProviderResolver()")
                    ] + componentParameters.map { parameter in
                        if let name = parameter.attributes.named?.name {
                            .expr("resolver.register(provider: InstanceProvider(instance: \(parameter.name)), name: \(name))")
                        } else {
                            .expr("resolver.register(provider: InstanceProvider(instance: \(parameter.name)))")
                        }
                    } + moduleTypes.map { moduleType in
                        .expr("_$Blade\(moduleType).register(resolver: resolver)")
                    } + componentEntryPoints.map { signature in
                        .expr("self.\(signature.returnType.toCamelCase())Provider = resolver.resolve(type: \(signature.returnType).self)")
                    }
                )
            )
        )
    }
}

private extension DeinitializerDeclSyntax {
    static func componentDeinit(moduleTypes: [String]) -> DeinitializerDeclSyntax {
        DeinitializerDeclSyntax(
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    moduleTypes.map { moduleType in
                        .expr("_$Blade\(moduleType).deregister(resolver: resolver)")
                    }
                )
            )
        )
    }
}

private extension FunctionDeclSyntax {
    static func componentEntryPoint(
        visibility: Visibility,
        entryPoint: ComponentEntryPoint
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax(visibility: visibility),
            name: TokenSyntax(stringLiteral: entryPoint.name),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax()
                ),
                returnClause: ReturnClauseSyntax(
                    type: TypeSyntax(stringLiteral: entryPoint.returnType)
                )
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    [
                        .expr("\(entryPoint.returnType.toCamelCase())Provider.get()")
                    ]
                )
            )
        )
    }
}
