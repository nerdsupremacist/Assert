
import Foundation

public struct Success {
    public let path: [String]
    public let message: String?
    public let file: StaticString
    public let function: StaticString
    public let line: UInt
}
