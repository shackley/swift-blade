struct InitializerBinding {
    let scope: Scope
    let parameters: [BindingParameter]
    let returnType: String
}

extension InitializerBinding: Binding {
    var providerName: String {
        "_$BladeDependencyProvider"
    }

    var functionName: String {
        returnType
    }
}
