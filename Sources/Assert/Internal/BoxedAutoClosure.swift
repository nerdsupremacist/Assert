
import Foundation

class BoxedAutoClosure<T> {
    private var isSet = false
    private var cached: T? = nil
    private let factory: () -> T

    init(_ factory: @escaping () -> T) {
        self.factory = factory
    }

    func load() -> T {
        if let cached = cached {
            return cached
        }

        let value = factory()
        cached = value
        return value
    }
}
