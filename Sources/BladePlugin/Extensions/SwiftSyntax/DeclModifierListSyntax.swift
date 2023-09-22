import SwiftSyntax
import Foundation

extension DeclModifierListSyntax {
    init(visibility: Visibility) {
        self.init(
            [ DeclModifierSyntax(name: .keyword(visibility.keyword)) ]
        )
    }
}

private extension Visibility {
    var keyword: Keyword {
        switch self {
        case .public: return .public
        case .internal: return .internal
        case .private: return .private
        }
    }
}
