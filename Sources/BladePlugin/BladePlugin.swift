import SwiftCompilerPlugin
import SwiftSyntaxMacros
import Foundation

@main
struct BladePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ComponentMacro.self,
        ModuleMacro.self,
        ProviderMacro.self
    ]
}
