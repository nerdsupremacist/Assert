
import Foundation

public struct EitherTest<A: Test, B: Test>: Test {
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

extension EitherTest: InternalTest {

    func test(_ context: TestContext) {
        switch storage {
        case .first(let test):
            context.use(test: test)
        case .second(let test):
            context.use(test: test)
        }
    }

}
