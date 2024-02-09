import SwiftSyntax
import Foundation

extension FunctionParameterSyntax {
    init(
        name: String,
        type: String,
        defaultValue: String? = nil,
        trailingComma: Bool = false
    ) {
        self.init(
            firstName: TokenSyntax(stringLiteral: name),
            type: TypeSyntax(stringLiteral: type),
            defaultValue: defaultValue.flatMap {
                InitializerClauseSyntax(value: ExprSyntax(stringLiteral: $0))
            },
            trailingComma: trailingComma ? TokenSyntax.commaToken() : nil
        )
    }
}
