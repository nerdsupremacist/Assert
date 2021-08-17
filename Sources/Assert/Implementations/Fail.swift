
import Foundation

public struct Fail: Test {
    public typealias Body = Never

    private let message: String?
    private let file: StaticString
    private let function: StaticString
    private let line: UInt

    public var body: Never {
        fatalError()
    }

    public init(message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
        
        self.message = message
        self.file = file
        self.function = function
        self.line = line
    }
}

extension Fail: InternalTest {

    func test(_ context: TestContext) {
        context.fail(message: message, file: file, function: function, line: line)
    }

}
