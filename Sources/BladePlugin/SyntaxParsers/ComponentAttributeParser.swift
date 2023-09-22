import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum ComponentAttributeParser {
    static func parse(
        attribute: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> ComponentAttribute {
        var moduleTypes: [String] = []

        attribute.arguments?.as(LabeledExprListSyntax.self)?.forEach { labeledExpr in
            switch labeledExpr.label?.text {
            case "modules":
                guard let elements = labeledExpr.expression.as(ArrayExprSyntax.self)?.elements else {
                    context.diagnose(
                        node: labeledExpr,
                        message: .invalidComponentModulesSyntax
                    )
                    return
                }
                moduleTypes = MetatypeParser.parse(array: elements)
            default: break
            }
        }

        return ComponentAttribute(
            moduleTypes: moduleTypes
        )
    }
}
