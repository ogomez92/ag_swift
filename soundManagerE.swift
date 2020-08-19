import Foundation
import AVFoundation
class SoundItem {
    var player: AVAudioPlayerNode
	var pitchController: AVAudioUnitVarispeed
	var file: AVAudioFile?
	var mixer: AVAudioMixerNode

	var pitch: Float {
		get {
			return self.pitchController.rate
		}
		set {
			self.pitchController.rate = newValue
		}
	}
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
	var loop = false
	var filename: String


	init!(_ fileName: String) {
		self.filename = fileName
		self.mixer = AVAudioMixerNode()
		do {
			let fileURL = Bundle.main.url(forResource: self.filename, withExtension: "m4a")
			self.file = try AVAudioFile(forReading: fileURL!)
			self.player = AVAudioPlayerNode()
			print("sound created")
		} catch {
			print("Error creating sound \(self.filename)")
			return nil
		}
			self.pitchController = AVAudioUnitVarispeed()
		}

	func checkNext() {
		if (self.loop) {
			do {
				try self.player.scheduleFile(self.file!, at: nil) {
					self.checkNext()
				}
			} catch {
print("error when scheduling loop")
			}
		}
	}
	func play() {
		print("playing")
		self.player.play()
	}
	deinit {
	}
}

class SoundManager {
	var sounds: [SoundItem] = []
	var engine: AVAudioEngine
	init() {
		self.engine = AVAudioEngine()
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback, mode: .default, options: [])
			try audioSession.setActive(true)
		} catch {
print("can't setup audio session.")
		}

	}

func connectNodes(_ sound: SoundItem) {
	DispatchQueue.global(qos: .background).sync {
	do {
		self.engine.attach(sound.player)
		self.engine.attach(sound.mixer)
		self.engine.attach(sound.pitchController)
		self.engine.connect(sound.mixer, to: self.engine.mainMixerNode, format: nil)
		self.engine.connect(sound.player, to: sound.mixer, format: nil)
		self.engine.connect(sound.player, to: sound.pitchController, format: nil)
		self.engine.connect(sound.pitchController, to: sound.mixer, format: nil)
		if (!self.engine.isRunning) {
			try self.engine.start()
		}
		try sound.player.scheduleFile(sound.file!, at: nil) {
			sound.checkNext()
		}
		print("nodes connected")
	} catch {
print("Error connecting nodes")
}
	}
}
	func create(_ filename: String) -> SoundItem? {
		do {
var newSound = try SoundItem(filename)
			print("connecting")
			try self.connectNodes(newSound!)
			print("connected")
			return newSound
		} catch {
	print("Cannot create sound item in sound manager for \(filename)")
	return nil
}

	}
}

