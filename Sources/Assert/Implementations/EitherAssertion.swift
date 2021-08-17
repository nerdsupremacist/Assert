
import Foundation

public struct EitherAssertion<A: Assertion, B: Assertion>: Assertion {
    public typealias Body = Never

    private enum Storage {
        case first(A)
        case second(B)
    }

    private let storage: Storage

    public var body: Never {
        fatalError()
    }

    init(first: A) {
        storage = .first(first)
    }

    init(second: B) {
        storage = .second(second)
    }
}

extension EitherAssertion: InternalAssertion {

    func assert(_ context: AssertionContext) {
        switch storage {
        case .first(let assertion):
            context.assert(assertion)
        case .second(let assertion):
            context.assert(assertion)
        }
    }

}
