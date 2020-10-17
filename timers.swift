import Foundation
import UIKit
class GameTimer {
var paused=false
	var time: Int=0
	var justStarted: Bool = true
	var updaterFunction: (Int) -> Void
	var previousTimestamp: TimeInterval
		@objc func displayRefreshed(displayLink: CADisplayLink) {
			print("starting refresh")
			if paused { return }
let currentTimestamp=displayLink.timestamp
let difference=currentTimestamp-previousTimestamp
			let differenceMilliseconds=Int((difference*1000))
			time+=differenceMilliseconds
			previousTimestamp=currentTimestamp
			if justStarted {
				print("just started")
				self.restart()
				justStarted=false
				return
			}
			print("updating")
updaterFunction(time)
		}
	func restart() {
		self.time=0
	}
	init() {
		previousTimestamp=NSDate().timeIntervalSinceNow
		self.updaterFunction = { time in
			print("initialized with "+String(time))
		}

		let displayLink = CADisplayLink(target: self, selector: #selector(displayRefreshed(displayLink:)))
		displayLink.add(to: .main, forMode: .default)

}
	func setFunction(_ updaterFunction: @escaping(Int) -> Void) {
		self.updaterFunction=updaterFunction
	}
}
//time to test

