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
	func speakVoQueued(_ text: String) {
		let attributedLabel = NSAttributedString(string: text, attributes: [NSAttributedString.Key.accessibilitySpeechQueueAnnouncement: true])

		UIAccessibility.post(notification: .announcement, argument: attributedLabel)
	}

	func speakVoDelayed(_ text: String) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			UIAccessibility.post(notification: .announcement, argument: text)
		}
}

}

let tts = SpeakUtilities()
