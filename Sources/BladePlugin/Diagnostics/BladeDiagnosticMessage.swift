import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntax

private let domain = "io.shackley.blade"

struct BladeDiagnosticMessage: DiagnosticMessage {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity

    init(message: String, id: String, severity: DiagnosticSeverity) {
        self.message = message
        self.diagnosticID = MessageID(domain: domain, id: id)
        self.severity = severity
    }
}

extension BladeDiagnosticMessage {
    static let invalidComponentModulesSyntax = BladeDiagnosticMessage(
        message: "The module list must be an array literal",
        id: "invalid_component_modules_syntax",
        severity: .error
    )

    static let invalidComponentType = BladeDiagnosticMessage(
        message: "@Component can only be attached to a protocol",
        id: "invalid_component_type",
        severity: .error
    )

    static let invalidComponentInitializerCount = BladeDiagnosticMessage(
        message: "Components can have at most 1 initializer",
        id: "invalid_component_initializer_count",
        severity: .error
    )

    static let invalidEntryPointFunctionParameters = BladeDiagnosticMessage(
        message: "Entry point functions must be parameterless",
        id: "invalid_entry_point_function_parameters",
        severity: .error
    )

    static let invalidEntryPointFunctionReturnType = BladeDiagnosticMessage(
        message: "Entry point functions must return a type",
        id: "invalid_entry_point_function_return_type",
        severity: .error
    )

    static let invalidModuleProvidesSyntax = BladeDiagnosticMessage(
        message: "The provides list must be an array literal",
        id: "invalid_module_provides_syntax",
        severity: .error
    )

    static let invalidModuleSubmodulesSyntax = BladeDiagnosticMessage(
        message: "The submodule list must be an array literal",
        id: "invalid_module_includes_syntax",
        severity: .error
    )

    static let invalidModuleType = BladeDiagnosticMessage(
        message: "@Module can only be attached to an empty enum",
        id: "invalid_module_type",
        severity: .error
    )

    static let invalidProviderPeer = BladeDiagnosticMessage(
        message: "@Provider must be attached to either an initializer, or a static function within a module",
        id: "invalid_provider_peer",
        severity: .error
    )

    static let invalidProviderFunctionModifier = BladeDiagnosticMessage(
        message: "@Provider functions must be static",
        id: "invalid_provider_function_modifier",
        severity: .error
    )

    static let invalidScope = BladeDiagnosticMessage(
        message: "A scope must be defined as a Scope literal",
        id: "invalid_scope",
        severity: .error
    )

    static let missingProviderFunctionReturnType = BladeDiagnosticMessage(
        message: "@Provider functions must return a non-Void type",
        id: "missing_provider_function_binding_return_type",
        severity: .error
    )

    static let namedProviderNotPermitted = BladeDiagnosticMessage(
        message: "Named @Providers can't be used with initializers",
        id: "named_provider_not_permitted",
        severity: .error
    )

    static let unexpectedParameterType = BladeDiagnosticMessage(
        message: "Unexpected parameter type",
        id: "unexpected_parameter_type",
        severity: .error
    )

    static let unknownProviderReturnType = BladeDiagnosticMessage(
        message: "Unable to determine return type for initializer-based @Provider",
        id: "unknown_provider_return_type",
        severity: .error
    )

    static let unnecessaryProviderFunctionReturnType = BladeDiagnosticMessage(
        message: "Specifying the provided type is no longer necessary. The `of` parameter will be removed in future versions of swift-blade.",
        id: "unnecessary_provider_function_binding_return_type",
        severity: .warning
    )
}

extension MacroExpansionContext {
    func diagnose(node: some SyntaxProtocol, message: BladeDiagnosticMessage) {
        diagnose(Diagnostic(node: node, message: message))
    }
}
