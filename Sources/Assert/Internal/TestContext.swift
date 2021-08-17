
import Foundation
@_implementationOnly import AssociatedTypeRequirementsVisitor

class TestContext {
    private class _State {
        let path: [String]
        private let previous: _State?

        convenience init() {
            self.init(path: [], previous: nil)
        }

        private init(path: [String], previous: _State?) {
            self.path = path
            self.previous = previous
        }

        func next(path: [String]) -> _State {
            return _State(path: self.path + path, previous: self)
        }

        func pop() -> _State? {
            return previous
        }
    }

    private var state: _State = _State()
    private(set) var successful: [Success] = []
    private(set) var failures: [Failure] = []

    func beginGroup(path: [String]) {
        self.state = state.next(path: path)
    }

    func endGroup() {
        self.state = state.pop() ?? self.state
    }

    func fail(message: String?,
              file: StaticString,
              function: StaticString,
              line: UInt) {

        let failure = Failure(path: state.path, message: message, file: file, function: function, line: line)
        failures.append(failure)
    }

    func pass(message: String?,
              file: StaticString,
              function: StaticString,
              line: UInt) {

        let success = Success(path: state.path, message: message, file: file, function: function, line: line)
        successful.append(success)
    }

    func use<Content : Test>(test: Content) {
        if let internalTest = test as? InternalTest {
            internalTest.test(self)
            return
        }

        let body = test.body
        use(test: body)
    }
}

extension TestContext {

    func unsafeUse(test value: Any) {
        let visitor = ContextBasedTestVisitor(context: self)
        Swift.assert(visitor(value) != nil)
    }

}

private protocol TestVisitor: AssociatedTypeRequirementsVisitor {
    associatedtype Visitor = TestVisitor
    associatedtype Input = Test
    associatedtype Output

    func callAsFunction<T : Test>(_ value: T) -> Output
}

extension TestVisitor {

    @inline(never)
    @_optimize(none)
    func _test() {
        _ = callAsFunction(Fail())
    }

}

private struct ContextBasedTestVisitor: TestVisitor {
    let context: TestContext

    func callAsFunction<T : Test>(_ value: T) {
        context.use(test: value)
    }
}
