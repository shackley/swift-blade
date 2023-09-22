/// An attribute used to distinguish between dependencies of the same type.
///
/// `@Named` can be attached to the parameter of `@Provider` function.
/// Named dependencies will be matched up with the `@Provider` that has the same name specified.
///
/// ## Example
///
/// ```swift
/// @Module
/// public enum ConfigModule {
///     @Provider
///     static func provideConfig(
///         @Named("value1") value1: String,
///         @Named("value2") value2: String
///     ) -> Config {
///         Config(value1: value1, value2: value2)
///     }
///
///     @Provider(named: "value1")
///     static func provideValue1() -> String {
///         "abc"
///     }
///
///     @Provider(named: "value2")
///     static func provideValue2() -> String {
///         "xyz"
///     }
/// }
/// ```
@propertyWrapper public struct Named<T> {
    public let wrappedValue: T

    public init(wrappedValue: T, _ qualifier: String) {
        self.wrappedValue = wrappedValue
    }
}
