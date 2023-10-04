/// An attribute used to distinguish between dependencies of the same type.
///
/// `@Named` can be attached to the parameter of `@Provider` function.
/// Named dependencies will be matched up with the `@Provider` that has the same name specified.
@propertyWrapper public struct Named<T> {
    public let wrappedValue: T

    public init(wrappedValue: T, _ qualifier: String) {
        self.wrappedValue = wrappedValue
    }
}
