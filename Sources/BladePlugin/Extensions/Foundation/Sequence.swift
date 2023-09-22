import Foundation

extension Sequence where Element: Hashable {
    func toSet() -> Set<Element> {
        Set(self)
    }
}
