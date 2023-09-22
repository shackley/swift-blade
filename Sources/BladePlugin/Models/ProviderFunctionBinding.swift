struct ProviderFunctionBinding {
    let scope: Scope
    let named: String?
    let functionName: String
    let parameters: [BindingParameter]
    let returnType: String
    let index: Int
}

extension ProviderFunctionBinding: Binding {
    var providerName: String {
        "_$Blade\(index)\(returnType.sanitized())DependencyProvider"
    }
}
