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
	var duration: Int {
		get {
			return Int(self.player.duration*1000)
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
		do {

		self.filename = fileName
			print(self.filename)
			let fileURL = Bundle.main.url(forResource: filename, withExtension: "m4a")
//			print("loaded file for "+self.filename)
			self.player = try! AVAudioPlayer(contentsOf: fileURL!)
			self.player.prepareToPlay()
		} catch {
//			print("error loading sound "+self.filename)
		}
	}
	func checkNext() {

	}
	func playAnd(_ what: @escaping() -> Void) {
		self.player.play()
		doAfter(Int(self.duration)) {
what()
		}
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
}

class SoundManager {
	var oneShot: SoundItem?
	var sounds: [SoundItem] = []
	func create(_ filename: String) -> SoundItem? {
		if let snd = SoundItem(filename) {
return snd
		} else {
			print("Cannot create sound item in sound manager for \(filename)")
		}
		return nil
	}
	func playOnce(_ file: String) -> Int {
oneShot=create(file)
		oneShot?.play()
		doAfter(oneShot!.duration*2) {
			self.oneShot=nil
		}
		return oneShot!.duration
	}
}

