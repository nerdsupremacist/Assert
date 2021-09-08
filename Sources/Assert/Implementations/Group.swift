
import Foundation

public struct Group<Content: Test>: Test {
    public typealias Body = Never

    private let path: [String]
    private let content: Content

    public var body: Never {
        fatalError()
    }

    public init(path: String, _ rest: String..., @TestBuilder content: () -> Content) {
        self.path = [path] + rest
        self.content = content()
    }
}

extension Group: InternalTest {

    func test(_ context: TestContext) {
        context.beginGroup(path: path)
        context.use(test: content)
        context.endGroup()
    }

}
