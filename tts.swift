import Foundation
import UIKit

class SpeakUtilities {
	var isVoRunning: Bool {
		get {
			return UIAccessibility.isVoiceOverRunning
		}
	}
	func speakVo(_ text: String) {
		UIAccessibility.post(notification: .announcement, argument: text)
	}
	func speakVoDelayed(_ text: String) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			UIAccessibility.post(notification: .announcement, argument: text)
		}
}

}

let tts = SpeakUtilities()
