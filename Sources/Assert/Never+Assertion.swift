
import Foundation

extension Never: Test {
    public typealias Body = Never

    public var body: Never {
        fatalError()
    }
}
