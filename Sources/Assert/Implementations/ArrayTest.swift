
import Foundation

public struct ArrayTest<Content: Test>: Test {
    public typealias Body = Never
    private let content: [Content]

    public var body: Never {
        fatalError()
    }

    init(_ content: [Content]) {
        self.content = content
    }
}

extension ArrayTest: InternalTest {
    func test(_ context: TestContext) {
        for (index, item) in content.enumerated() {
            context.beginGroup(path: ["Index \(index)"])
            context.use(test: item)
            context.endGroup()
        }
    }
}
