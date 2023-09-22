import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(BladePlugin)
import BladePlugin

let testMacros: [String: Macro.Type] = [
    "Component": ComponentMacro.self,
    "Module": ModuleMacro.self,
    "Provider": ProviderMacro.self
]
#endif

final class BladePluginTests: XCTestCase {
    func test() throws {
        #if canImport(BladePlugin)
        assertMacroExpansion("""
            """,
            expandedSource: """
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
