import Foundation
import AVFoundation
class EngineItem {
	var engine: SoundEngine
	var isPlaying: Bool {
		get {
			return self.player.isPlaying
		}
	}
    var player: AVAudioPlayerNode
	var pitchController: AVAudioUnitVarispeed
	var file: AVAudioFile?
	//var mixer: AVAudioMixerNode
	var looping: Bool=false
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
	var loop: Bool {
		set {
			if newValue {
				self.looping=true
			}
			else {
				self.looping=false
			}
		}
		get {
			return self.looping
		}
	}
	var filename: String


	init!(_ fileName: String, _ engine: SoundEngine) {
		self.engine=engine
		self.filename = fileName
		//self.mixer = AVAudioMixerNode()
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
	func stop() {
		self.player.stop()
	}
	func checkNext() {
		if (self.looping) {
				self.player.scheduleFile(self.file!, at: nil) {
					self.checkNext()
}
		}
	}
	func play() {
		self.player.scheduleFile(self.file!, at: nil) {
			self.checkNext()
		}
		self.player.play()
	}
	func destroy() {

		self.engine.engine.detach(player)
		self.engine.engine.detach(pitchController)
	}
	deinit {
		tts.speakVo("dead")
	}
}

class SoundEngine {
	var sounds: [EngineItem] = []
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

func connectNodes(_ sound: EngineItem) {
	DispatchQueue.global(qos: .background).sync {
	do {
		self.engine.attach(sound.player)
		self.engine.attach(sound.pitchController)
		print("attached")
		self.engine.connect(sound.player, to: sound.pitchController, format: nil)
//		self.engine.connect(sound.player, to: self.engine.mainMixerNode, format: nil)
		self.engine.connect(sound.pitchController, to: self.engine.mainMixerNode, format: nil)
		print("all nodes connected.")
		if (!self.engine.isRunning) {
			print("not running")
			try self.engine.start()
		}
		print("scheduling file")
		//sound.player.scheduleFile(sound.file!, at: nil) {
		//}
		print("nodes connected")
	} catch {
print("Error connecting nodes")
}
	}
}
	func create(_ filename: String) -> EngineItem? {
let newSound = EngineItem(filename,self)
			print("connecting")
			self.connectNodes(newSound!)
			print("connected")
			return newSound

	}
}

