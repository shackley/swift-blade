protocol Binding {
    var scope: Scope { get }
    var providerName: String { get }
    var functionName: String { get }
    var parameters: [BindingParameter] { get }
    var returnType: String { get }
}
