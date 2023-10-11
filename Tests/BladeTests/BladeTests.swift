import XCTest

@testable import Blade

public protocol Foo {}
public protocol Bar {}
public protocol Baz {}

public struct Config {
    let n1: Int
    let n2: Int
}

public class FooImpl: Foo {
    public static var initializations: Int = 0
    private let config: Config
    private let key1: String
    private let key2: String

    @Provider(of: FooImpl.self)
    public init(
        config: Config,
        @Named("key1") key1: String,
        @Named("key2") key2: String
    ) {
        self.config = config
        self.key1 = key1
        self.key2 = key2
        Self.initializations += 1
    }
}

public class BarImpl: Bar {
    public static var initializations: Int = 0
    private let foo: Lazy<Foo>

    @Provider(of: BarImpl.self)
    public init(foo: Lazy<Foo>) {
        self.foo = foo
        Self.initializations += 1
    }
}

public class BazImpl: Baz {
    public static var initializations: Int = 0
    private let foo: Foo

    @Provider(of: BazImpl.self, scope: .singleton)
    public init(foo: Foo) {
        self.foo = foo
        Self.initializations += 1
    }
}

struct A<T> {
    let a: T
}

struct B {
    let b: String
}

struct C {
    @Provider(of: C.self)
    init() {}
}

struct ABC {
    let a: A<Int>
    let b: B
    let c: C
}

public class Alphabet {
    public static var initializations: Int = 0
    private let abc: ABC
    private let key1: String

    @Provider(of: Alphabet.self, scope: .singleton)
    init(abc: ABC, @Named("key1") key1: String) {
        self.abc = abc
        self.key1 = key1
        Self.initializations += 1
    }
}

@Module
public enum KeyModule {
    @Provider(named: "key1")
    static func provideKey1() -> String {
        "1"
    }

    @Provider(named: "key2")
    static func provideKey2() -> String {
        "2"
    }
}

@Module(
    provides: [FooImpl.self, BarImpl.self, BazImpl.self],
    submodules: [KeyModule.self]
)
public enum FooBarModule {
    @Provider(scope: .singleton)
    static func provideFoo(impl: FooImpl) -> Foo {
        impl
    }

    @Provider
    static func provideBar(impl: BarImpl) -> Bar {
        impl
    }

    @Provider
    static func provideBaz(impl: BazImpl) -> Baz {
        impl
    }
}

@Module(provides: [Alphabet.self, C.self])
enum AlphabetModule {
    @Provider
    static func provideA() -> A<Int> {
        A(a: 1)
    }

    @Provider
    static func provideB() -> B {
        B(b: "b")
    }

    @Provider
    static func provideABC(a: A<Int>, b: B, c: C) -> ABC {
        ABC(a: a, b: b, c: c)
    }
}

// @Component(modules: [FooBarModule.self])
public protocol RootComponent {
    init(config: Config)

    func bar() -> Bar
    func baz() -> Baz
}

public class BladeRootComponent: RootComponent {
    private let resolver: DependencyProviderResolver
    private let barProvider: any DependencyProvider<Bar>
    private let bazProvider: any DependencyProvider<Baz>
    public required init(config: Config) {
        self.resolver = DependencyProviderResolver(parent: nil)
        resolver.register(provider: InstanceProvider(instance: config))
        _$BladeFooBarModule.register(resolver: resolver)
        self.barProvider = resolver.resolve(type: Bar.self)
        self.bazProvider = resolver.resolve(type: Baz.self)
    }
    deinit {
        _$BladeFooBarModule.deregister(resolver: resolver)
        _$BladeAlphabetModule.deregister(resolver: resolver)
    }
    public func alphabetComponent() -> AlphabetComponent {
        BladeAlphabetComponent(parent: resolver)
    }
    public func bar() -> Bar {
        barProvider.get()
    }
    public func baz() -> Baz {
        bazProvider.get()
    }
}

// @Component(modules: [AlphabetModule.self])
public protocol AlphabetComponent {
    func alphabet() -> Alphabet
}

public class BladeAlphabetComponent: AlphabetComponent {
    private let resolver: DependencyProviderResolver
    private let alphabetProvider: any DependencyProvider<Alphabet>
    public required init(parent: DependencyProviderResolver? = nil) {
        self.resolver = DependencyProviderResolver(parent: parent)
        _$BladeAlphabetModule.register(resolver: resolver)
        self.alphabetProvider = resolver.resolve(type: Alphabet.self)
    }
    deinit {
        _$BladeFooBarModule.deregister(resolver: resolver)
        _$BladeAlphabetModule.deregister(resolver: resolver)
    }
    public func alphabet() -> Alphabet {
        alphabetProvider.get()
    }
}

final class BladeTests: XCTestCase {
    func test() throws {
        let config = Config(n1: 1, n2: 2)
        let rootComponent = BladeRootComponent(config: config)
        _ = rootComponent.bar()
        _ = rootComponent.bar()
        _ = rootComponent.baz()
        _ = rootComponent.baz()
        XCTAssertEqual(FooImpl.initializations, 1)
        XCTAssertEqual(BarImpl.initializations, 2)
        XCTAssertEqual(BazImpl.initializations, 1)
        let alphabetComponent = rootComponent.alphabetComponent()
        _ = alphabetComponent.alphabet()
        XCTAssertEqual(Alphabet.initializations, 1)
    }
}
