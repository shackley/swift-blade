struct DependencyKey: Hashable {
    private let type: ObjectIdentifier
    private let name: String?

    static func from<T>(type: T.Type, name: String? = nil) -> DependencyKey {
        DependencyKey(type: ObjectIdentifier(type), name: name)
    }
}
