
import Foundation

public struct TupleTest<Tuple>: Test {
    public typealias Body = Never

    private let storage: Tuple

    init(_ storage: Tuple) {
        self.storage = storage
    }

    public var body: Never {
        fatalError()
    }
}

extension TupleTest: InternalTest {

    func test(_ context: TestContext) {
        let mirror = Mirror(reflecting: storage)
        for (_, value) in mirror.children {
            context.unsafeUse(test: value)
        }
    }

}
