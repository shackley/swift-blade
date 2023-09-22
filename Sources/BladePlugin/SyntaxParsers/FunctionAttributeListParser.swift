import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum FunctionAttributeListParser {
    static func parse(
        attributeList: AttributeListSyntax,
        context: some MacroExpansionContext
    ) -> FunctionAttributes {
        var provider: ProviderAttribute? = nil

        for attribute in attributeList {
            guard let attribute = attribute.as(AttributeSyntax.self) else {
                continue
            }

            let name = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text

            switch name {
            case "Provider":
                provider = ProviderAttributeParser.parse(attribute: attribute, context: context)
            default:
                break
            }
        }

        return FunctionAttributes(
            provider: provider
        )
    }
}
