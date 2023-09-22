import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum ProviderAttributeParser {
    static func parse(
        attribute: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> ProviderAttribute {
        var returnType: String? = nil
        var scope: Scope = .unscoped
        var named: String? = nil

        attribute.arguments?.as(LabeledExprListSyntax.self)?.forEach { labeledExpr in
            switch labeledExpr.label?.text {
            case "of":
                returnType = MetatypeParser.parse(expression: labeledExpr.expression)
            case "scope":
                guard
                    let expression = labeledExpr.expression.as(MemberAccessExprSyntax.self),
                    let scopeCase = Scope(rawValue: expression.declName.baseName.text)
                else {
                    context.diagnose(
                        node: labeledExpr,
                        message: .invalidScope
                    )
                    return
                }
                scope = scopeCase
            case "named":
                named = labeledExpr.expression.description.trimmed()
            default: break
            }
        }

        return ProviderAttribute(
            returnType: returnType,
            scope: scope,
            named: named
        )
    }
}
