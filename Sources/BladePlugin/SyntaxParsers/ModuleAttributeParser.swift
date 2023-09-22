import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum ModuleAttributeParser {
    static func parse(
        attribute: AttributeSyntax,
        context: some MacroExpansionContext
    ) -> ModuleAttribute {
        var submoduleTypes: [String] = []
        var providesTypes: [String] = []

        attribute.arguments?.as(LabeledExprListSyntax.self)?.forEach { labeledExpr in
            switch labeledExpr.label?.text {
            case "provides":
                guard let elements = labeledExpr.expression.as(ArrayExprSyntax.self)?.elements else {
                    context.diagnose(
                        node: labeledExpr,
                        message: .invalidModuleProvidesSyntax
                    )
                    return
                }
                providesTypes = MetatypeParser.parse(array: elements)
            case "submodules":
                guard let elements = labeledExpr.expression.as(ArrayExprSyntax.self)?.elements else {
                    context.diagnose(
                        node: labeledExpr,
                        message: .invalidModuleSubmodulesSyntax
                    )
                    return
                }
                submoduleTypes = MetatypeParser.parse(array: elements)
            default: break
            }
        }

        return ModuleAttribute(
            providesTypes: providesTypes,
            submoduleTypes: submoduleTypes
        )
    }
}
