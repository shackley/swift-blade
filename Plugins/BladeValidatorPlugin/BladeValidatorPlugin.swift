import PackagePlugin
import Foundation

@main
struct SourceKitPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }

        let inputFilePath = context.pluginWorkDirectory
            .appending(subpath: "input.csv")
            .string

        let inputData = sourceTarget.sourceFiles(withSuffix: ".swift")
            .lazy
            .map(\.path)
            .map(\.string)
            .joined(separator: ",")
            .utf8

        try Data(inputData).write(to: URL(fileURLWithPath: inputFilePath))

        return [
            .buildCommand(
                displayName: "Blade Validator",
                executable: try context.tool(named: "BladeValidatorCommand").path,
                arguments: [ inputFilePath ],
                environment: [:],
                outputFiles: []
            )
        ]
    }
}
