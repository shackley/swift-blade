import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum BindingParameterParser {
    static func parse(
        parameter: FunctionParameterSyntax,
        context: some MacroExpansionContext
    ) -> BindingParameter? {
        guard let typeSyntax = parameter.type.as(IdentifierTypeSyntax.self) else {
            context.diagnose(
                node: parameter,
                message: .unexpectedParameterType
            )
            return nil
        }

        let variant: BindingParameter.Variant = switch typeSyntax.name.text {
            case "Lazy": .lazy
            default: .instance
        }

        guard let type = parse(typeSyntax: typeSyntax, variant: variant) else {
            context.diagnose(
                node: parameter,
                message: .unexpectedParameterType
            )
            return nil
        }

        let name = parameter.firstName.text
        let attributes = BindingParameterAttributesParser.parse(attributeList: parameter.attributes)
        
        return BindingParameter(
            attributes: attributes,
            name: name,
            type: type,
            variant: variant
        )
    }

    private static func parse(
        typeSyntax: IdentifierTypeSyntax,
        variant: BindingParameter.Variant
    ) -> String? {
        switch variant {
        case .instance:
            return typeSyntax.description
        case .lazy:
            guard let wrappedType = typeSyntax.genericArgumentClause?.arguments.first?.description.trimmed() else {
                return nil
            }
            return wrappedType
        }
    }
}
