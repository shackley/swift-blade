import Foundation
import SwiftParser
import SwiftSyntax

public class Node {
    public let identifier: ObjectIdentifier
    public var children: [Node] = []

    public init(identifier: ObjectIdentifier) {
        self.identifier = identifier
    }
}

public func validate(swiftFilePaths: [String]) throws {
    for swiftFilePath in swiftFilePaths {
        let swiftFileContents = try String(
            contentsOf: URL(fileURLWithPath: swiftFilePath),
            encoding: .utf8
        )

        let syntax = Parser.parse(source: swiftFileContents)

        syntax.statements.forEach { codeBlockItem in
            switch codeBlockItem.item {
            case .decl(_):
                <#code#>
            case .stmt(_):
                <#code#>
            case .expr(_):
                <#code#>
            }
//            print(codeBlockItem.description)
        }
    }
}

public func validate(root: Node, providers: Set<ObjectIdentifier>) {
    var visited: Set<ObjectIdentifier> = [root.identifier]
    var stack: Set<ObjectIdentifier> = [root.identifier]

    for node in root.children {
        
    }
}
