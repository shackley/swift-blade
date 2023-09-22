import Foundation
import SwiftSyntax

enum BindingParameterAttributesParser {
    static func parse(attributeList: AttributeListSyntax) -> BindingParameterAttributes {
        var named: NamedAttribute?

        for attribute in attributeList {
            guard let attribute = attribute.as(AttributeSyntax.self) else {
                continue
            }

            let name = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text

            switch name {
            case "Named":
                guard let name = attribute.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.description else {
                    continue
                }
                named = NamedAttribute(name: name)
            default:
                break
            }
        }

        return BindingParameterAttributes(
            named: named
        )
    }
}

