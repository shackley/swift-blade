import SwiftSyntax
import Foundation

extension TypeAliasDeclSyntax {
    init(
        visibility: Visibility,
        alias: String,
        type: String
    ) {
        self.init(
            modifiers: DeclModifierListSyntax(visibility: visibility),
            name: TokenSyntax(stringLiteral: alias),
            initializer: TypeInitializerClauseSyntax(value: TypeSyntax(stringLiteral: type))
        )
    }
}
