struct BindingParameter {
    enum Variant {
        case instance
        case lazy
    }

    let attributes: BindingParameterAttributes
    let name: String
    let type: String
    let variant: Variant
}
