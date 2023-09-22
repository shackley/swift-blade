import SwiftSyntax
import Foundation

extension CodeBlockItemSyntax {
    static func expr(_ stringLiteral: String) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax(item: .expr(ExprSyntax(stringLiteral: stringLiteral)))
    }

    static func stmt(_ stringLiteral: String) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax(item: .stmt(StmtSyntax(stringLiteral: stringLiteral)))
    }
}
