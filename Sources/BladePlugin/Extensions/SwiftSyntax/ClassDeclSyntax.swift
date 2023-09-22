import SwiftSyntax
import Foundation

extension ClassDeclSyntax {
    init(
        visibility: Visibility,
        name: String,
        inheritedTypes: [String] = [],
        typeAliasDecls: [TypeAliasDeclSyntax] = [],
        variableDecls: [VariableDeclSyntax] = [],
        initDecls: [InitializerDeclSyntax] = [],
        deinitDecls: [DeinitializerDeclSyntax] = [],
        functionDecls: [FunctionDeclSyntax] = []
    ) {
        let typeAliasMembers = typeAliasDecls.map { MemberBlockItemSyntax(decl: $0) }
        let variableMembers = variableDecls.map { MemberBlockItemSyntax(decl: $0) }
        let initMembers = initDecls.map { MemberBlockItemSyntax(decl: $0) }
        let deinitMembers = deinitDecls.map { MemberBlockItemSyntax(decl: $0) }
        let functionMembers = functionDecls.map { MemberBlockItemSyntax(decl: $0) }

        self.init(
            modifiers: DeclModifierListSyntax(visibility: visibility),
            name: TokenSyntax(stringLiteral: name),
            inheritanceClause: inheritedTypes.isEmpty ? nil : InheritanceClauseSyntax(
                    inheritedTypes: InheritedTypeListSyntax(
                        inheritedTypes.map { InheritedTypeSyntax(type: TypeSyntax(stringLiteral: $0)) }
                )
            ),
            memberBlock: MemberBlockSyntax(
                members: MemberBlockItemListSyntax(
                    typeAliasMembers + variableMembers + initMembers + deinitMembers + functionMembers
                )
            )
        )
    }
}
