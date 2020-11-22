import Foundation

final class Throttler {
    private var interval: TimeInterval
    private var searchTask: DispatchWorkItem?

    init(timeInterval: TimeInterval = 1) {
        interval = timeInterval
    }

    func throttle(block: @escaping () -> Void) {
        cancel()
        let task = DispatchWorkItem {
            block()
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: task)
    }

    func cancel() {
        searchTask?.cancel()
    }
}
