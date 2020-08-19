import Foundation
import AVFoundation

class SoundItem {
    var player: AVAudioPlayer
	var pitchController: AVAudioUnitVarispeed
	var file: AVAudioFile?
	var volume: Float {
		get {
			return self.player.volume

		}
		set {
			self.player.volume = newValue
		}
	}	
	var pitch: Float
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
		self.pitch=-1
		do {
			let fileURL = Bundle.main.url(forResource: filename, withExtension: "m4a")
			self.player = try AVAudioPlayer(contentsOf: fileURL!)
			self.player.prepareToPlay()

			print("sound created")
		} catch {
			print("Error creating sound \(self.filename)")
			return nil
		}
pitchController = AVAudioUnitVarispeed()
		pitchController.rate = 1
	}
	func checkNext() {

	}
	func play() {
		print("playing")
		let result = self.player.play()
		print(result)
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

