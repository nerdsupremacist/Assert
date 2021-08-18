
import Foundation

// MARK: Structure

public struct Assert<PassValue, FollowUp : Test> {
    private let test: () -> AssertionResult<PassValue>
    private let message: String?
    private let followUp: (PassValue) -> FollowUp

    private let file: StaticString
    private let function: StaticString
    private let line: UInt

    public init(message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                _ test: @escaping () -> AssertionResult<PassValue>,
                @TestBuilder followUp: @escaping (PassValue) -> FollowUp) {
        
        self.test = test
        self.message = message
        self.file = file
        self.function = function
        self.line = line
        self.followUp = followUp
    }
}

// MARK: Result Handling

public enum AssertionResult<Value> {
    case pass(Value)
    case fail
}

extension AssertionResult where Value == () {

    public static let pass: AssertionResult<()> = .pass(())

}

// MARK: Test Implementation

extension Assert: Test {
    public var body: some Test {
        switch test() {
        case .pass(let value):
            Pass(message: message, file: file, function: function, line: line)
            followUp(value)
        case .fail:
            Fail(message: message, file: file, function: function, line: line)
        }
    }
}

// MARK: Conditions

extension Assert where PassValue == () {
    public init(message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                _ condition: @escaping () -> Bool,
                @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message, file: file, function: function, line: line, { condition() ? .pass : .fail }, followUp: followUp)
    }

    public init(_ condition: @autoclosure @escaping () -> Bool,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message, file: file, function: function, line: line, condition, followUp: followUp)
    }
}

extension Assert where FollowUp == EmptyTest, PassValue == () {

    public init(message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                _ condition: @escaping () -> Bool) {

        self.init(message: message, file: file, function: function, line: line, condition, followUp: { EmptyTest() })
    }

    public init(_ condition: @autoclosure @escaping () -> Bool,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {

        self.init(message: message, file: file, function: function, line: line, condition)
    }

}

// MARK: Equatable

extension Assert where PassValue == () {
    public init<T : Equatable>(_ lhs: @escaping @autoclosure () -> T,
                               equals rhs: @escaping @autoclosure () -> T,
                               message: String? = nil,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line,
                               @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { lhs() == rhs() },
                  followUp: followUp)
    }


    public init<T : Equatable>(_ lhs: @escaping @autoclosure () -> T,
                               doesNotEqual rhs: @escaping @autoclosure () -> T,
                               message: String? = nil,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line,
                               @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { lhs() != rhs() },
                  followUp: followUp)
    }
}

extension Assert where FollowUp == EmptyTest, PassValue == () {
    public init<T : Equatable>(_ lhs: @escaping @autoclosure () -> T,
                               equals rhs: @escaping @autoclosure () -> T,
                               message: String? = nil,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { lhs() == rhs() })
    }


    public init<T : Equatable>(_ lhs: @escaping @autoclosure () -> T,
                               doesNotEqual rhs: @escaping @autoclosure () -> T,
                               message: String? = nil,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line,
                               @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { lhs() != rhs() })
    }
}

// MARK: Optionals

extension Assert where PassValue == () {
    public init<T>(isNil value: @escaping @autoclosure () -> T?,
                   message: String? = nil,
                   file: StaticString = #file,
                   function: StaticString = #function,
                   line: UInt = #line,
                   @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { value() == nil },
                  followUp: followUp)
    }

    public init<T>(isNotNil value: @escaping @autoclosure () -> T?,
                   message: String? = nil,
                   file: StaticString = #file,
                   function: StaticString = #function,
                   line: UInt = #line,
                   @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { value() != nil },
                  followUp: followUp)
    }
}

extension Assert where FollowUp == EmptyTest, PassValue == () {
    public init<T>(isNil value: @escaping @autoclosure () -> T?,
                   message: String? = nil,
                   file: StaticString = #file,
                   function: StaticString = #function,
                   line: UInt = #line) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { value() == nil },
                  followUp: { EmptyTest() })
    }

    public init<T>(isNotNil value: @escaping @autoclosure () -> T?,
                   message: String? = nil,
                   file: StaticString = #file,
                   function: StaticString = #function,
                   line: UInt = #line) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  { value() != nil },
                  followUp: { EmptyTest() })
    }
}

extension Assert {
    public init(isNotNil value: @escaping @autoclosure () -> PassValue?,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                @TestBuilder followUp: @escaping (PassValue) -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    if let value = value() {
                        return .pass(value)
                    }

                    return .fail
                  },
                  followUp: followUp)
    }
}

// MARK: Errors

extension Assert where PassValue == Error {
    public init(throws block: @escaping @autoclosure () throws -> Void,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                @TestBuilder followUp: @escaping (PassValue) -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    do {
                        try block()
                        return .fail
                    } catch {
                        return .pass(error)
                    }
                  },
                  followUp: followUp)
    }
}

extension Assert where PassValue == () {
    public init(throws block: @escaping @autoclosure () throws -> Void,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    do {
                        try block()
                        return false
                    } catch {
                        return true
                    }
                  },
                  followUp: followUp)
    }

    public init(doesNotThrow block: @escaping @autoclosure () throws -> Void,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line,
                @TestBuilder followUp: @escaping () -> FollowUp) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    do {
                        try block()
                        return true
                    } catch {
                        return false
                    }
                  },
                  followUp: followUp)
    }
}

extension Assert where PassValue == (), FollowUp == EmptyTest {
    public init(throws block: @escaping @autoclosure () throws -> Void,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    do {
                        try block()
                        return false
                    } catch {
                        return true
                    }
                  })
    }

    public init(doesNotThrow block: @escaping @autoclosure () throws -> Void,
                message: String? = nil,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {

        self.init(message: message,
                  file: file,
                  function: function,
                  line: line,
                  {
                    do {
                        try block()
                        return true
                    } catch {
                        return false
                    }
                  })
    }
}
