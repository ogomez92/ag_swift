import Foundation
import AVFoundation

class SoundItem {
    var player: AVAudioPlayer

	var file: AVAudioFile?
	var volume: Float {
		get {
			return self.player.volume

		}
		set {
			self.player.volume = newValue
		}
	}	

	var pan: Float {
		get {
			return self.player.pan

		}
		set {
			self.player.pan = newValue
		}
	}
	var loop: Bool {
		get {
			self.player.numberOfLoops == 0 ? false : true
		}
		set {
			if !newValue { self.player.numberOfLoops = 0 }
			if newValue { self.player.numberOfLoops = -1 }
		}
	}
	var filename: String
	init!(_ fileName: String) {
		self.filename = fileName
			let fileURL = Bundle.main.url(forResource: filename, withExtension: "m4a")
			self.player = try! AVAudioPlayer(contentsOf: fileURL!)
			self.player.prepareToPlay()
	}
	func checkNext() {

	}
	func play() {
		self.player.play()
	}
	func stop() {
		self.player.stop()
	}
	func replay() {
		self.player.stop()
		self.player.currentTime = 0
		self.player.play()
	}
	func pause() {
		self.player.pause()
	}
	func fade() {
		self.player.setVolume(0.0, fadeDuration: 1.5)
	}
	deinit {
	}
}

class SoundManager {
	var sounds: [SoundItem] = []
	func create(_ filename: String) -> SoundItem? {
		if let snd = SoundItem(filename) {
return snd
		} else {
			print("Cannot create sound item in sound manager for \(filename)")
		}
		return nil
	}
}

