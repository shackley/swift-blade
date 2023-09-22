import Foundation
import SwiftSyntax

enum MetatypeParser {
    static func parse(array: ArrayElementListSyntax) -> [String] {
        array.compactMap { parse(expression: $0.expression) }
    }

    static func parse(expression: ExprSyntax) -> String? {
        expression.as(MemberAccessExprSyntax.self)?
            .base?
            .as(DeclReferenceExprSyntax.self)?
            .baseName
            .text
    }
}

