#  Installation

Integrate swift-blade into a SwiftPM package.

## Overview

Declare swift-blade as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/shackley/swift-blade", from: "0.2.0")
```

Add Blade as a dependency to your target(s):

```swift
dependencies: [
    .product(name: "Blade", package: "swift-blade")
]
```
