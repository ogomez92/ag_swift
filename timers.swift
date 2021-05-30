import Foundation
import UIKit
class GameTimer {
    var paused = false
    var time: Int = 0
    var justStarted: Bool = true
    var updaterFunction: (Int) -> Void
    var previousTimestamp: TimeInterval
    func pause() {
        paused = true
    }

    @objc func displayRefreshed(displayLink: CADisplayLink) {
        let currentTimestamp = displayLink.timestamp
        if justStarted {
            previousTimestamp = currentTimestamp
            justStarted = false
            print("just started set to false")
        }

        let difference = currentTimestamp - previousTimestamp
        let differenceMilliseconds = Int(difference * 1000)
        time += differenceMilliseconds
        previousTimestamp = currentTimestamp

        print("timer: \(differenceMilliseconds) with a total time of \(time)")
        if paused { return }
        print("call time now")
        updaterFunction(time)
    }

    func restart() {
        time = 0
    }

    init() {
        previousTimestamp = NSDate().timeIntervalSince1970
        updaterFunction = { _ in
        }

        let displayLink = CADisplayLink(target: self, selector: #selector(displayRefreshed(displayLink:)))
        displayLink.add(to: .current, forMode: .default)
    }

    func setFunction(_ updaterFunction: @escaping (Int) -> Void) {
        self.updaterFunction = updaterFunction
    }
}
