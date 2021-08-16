
import Foundation
@_implementationOnly import AssociatedTypeRequirementsVisitor

class AssertionContext {
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

    func assert<Content : Assertion>(_ assertion: Content) {
        if let internalAssertion = assertion as? InternalAssertion {
            internalAssertion.assert(self)
            return
        }

        let body = assertion.body
        assert(body)
    }
}

extension AssertionContext {

    func unsafeAssert(_ value: Any) {
        let visitor = ContextBasedAssertionVisitor(context: self)
        Swift.assert(visitor(value) != nil)
    }

}

private protocol AssertionVisitor: AssociatedTypeRequirementsVisitor {
    associatedtype Visitor = AssertionVisitor
    associatedtype Input = Assertion
    associatedtype Output

    func callAsFunction<T : Assertion>(_ value: T) -> Output
}

extension AssertionVisitor {

    @inline(never)
    @_optimize(none)
    func _test() {
        _ = callAsFunction(Fail())
    }

}

private struct ContextBasedAssertionVisitor: AssertionVisitor {
    let context: AssertionContext

    func callAsFunction<T : Assertion>(_ value: T) {
        context.assert(value)
    }
}
