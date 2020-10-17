import Foundation
import UIKit
import AVFoundation
class SpeakUtilities {
	let synth=AVSpeechSynthesizer()
	var alwaysVo: Bool=false
	var isVoRunning: Bool {
		get {
			return UIAccessibility.isVoiceOverRunning
		}
	}
	func stopSynth() {
		tts.synth.stopSpeaking(at: .immediate)
	}

	func speakVo(_ text: String) {
		if isVoRunning {
			UIAccessibility.post(notification: .announcement, argument: text)
	} else {
		if self.alwaysVo { return }
speakTTS(text)
	}
	}
	func speakVoQueued(_ text: String) {
		if isVoRunning {
			let attributedLabel = NSAttributedString(string: text, attributes: [NSAttributedString.Key.accessibilitySpeechQueueAnnouncement: true])
			UIAccessibility.post(notification: .announcement, argument: attributedLabel)
		} else {
			if self.alwaysVo { return }
speakTTS(text)
		}
	}

	func speakVoDelayed(_ text: String) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			if self.isVoRunning {
				UIAccessibility.post(notification: .announcement, argument: text)
		} else {
			if self.alwaysVo { return }
			self.speakTTS(text)
		}
		}
}
func speakTTS(_ text: String) {

	let utt=AVSpeechUtterance(string: text)
	if #available(iOS 14, *) {
	utt.prefersAssistiveTechnologySettings=true
	}
	utt.rate=0.6
	synth.speak(utt)
}
	}
let tts = SpeakUtilities()
