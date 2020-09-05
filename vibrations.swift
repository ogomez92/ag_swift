import Foundation

import CoreHaptics

class HapticsManager {
	var engine: CHHapticEngine?
	init() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		do {
			self.engine = try CHHapticEngine()
			try engine?.start()
			print("Haptics enabled.")
		} catch {
			print("Haptics error: \(error.localizedDescription)")
		}
	}
	func epicFail() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		var events = [CHHapticEvent]()
		let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
		let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
		var time: Float = 0
		for _ in stride(from: 1, to: 10, by: 1) {
			time+=0.02;
			let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: TimeInterval(time))
			events.append(event)
		}
		do {
			let pattern = try CHHapticPattern(events: events, parameters: [])
			let player = try engine?.makePlayer(with: pattern)
			try player?.start(atTime: 0)
		} catch {
			print("Failed to vibraten: \(error.localizedDescription).")
		}
	}
}
