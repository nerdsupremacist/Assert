# Assert
A simple DSL to write tests and collect assertiosn without relying on XCTest.

## Why

If you want to run tests in some other environment than XCTest, or want to manipulate assertions based on some other dynamic context, or perhaps perform some other analysis of test results, Assert provides you this with a very simple DSL

## Example

```swift
let results = test {
  Assert(true)
  Assert(1, equals: 1, "One should equal one")
  Fail("This should fail...")
}

print(results.failures) // [Failure(message: ""This should fail...", file: ..., function: ..., line: ...)]
```
