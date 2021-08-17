
import Foundation

extension Optional: Test where Wrapped: Test {
    public typealias Body = Never

    public var body: Never {
        fatalError()
    }
}

extension Optional: InternalTest where Wrapped: Test {

    func test(_ context: TestContext) {
        if let wrapped = self {
            context.use(test: wrapped)
        }
    }

}
