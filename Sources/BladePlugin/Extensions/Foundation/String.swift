import Foundation

extension String {
    func toCamelCase() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    func trimmed() -> String {
        trimmingCharacters(in: .whitespaces)
    }

    func sanitized() -> String {
        components(separatedBy: .alphanumerics.inverted).joined()
    }
}
