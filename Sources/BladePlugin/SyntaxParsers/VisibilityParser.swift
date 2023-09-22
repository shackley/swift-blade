import Foundation
import SwiftSyntax

enum VisibilityParser {
    static func parse(modifierList: DeclModifierListSyntax) -> Visibility {
        for modifier in modifierList {
            switch modifier.name.text {
            case "public": return .public
            case "internal": return .internal
            case "private": return .private
            default: break
            }
        }

        return .internal
    }
}
