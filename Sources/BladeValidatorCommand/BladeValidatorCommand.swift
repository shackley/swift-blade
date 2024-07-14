import ArgumentParser
import Foundation
import BladeValidator

@main
struct BladeValidatorCommand: ParsableCommand {
    @Argument
    var inputFilePath: String

    func run() throws {
        let input = try String(
            contentsOf: URL(fileURLWithPath: inputFilePath),
            encoding: .utf8
        )

        let swiftFilePaths = input
            .split(separator: ",")
            .map(String.init)

        try BladeValidator.validate(swiftFilePaths: swiftFilePaths)
    }
}
