import AVFoundation
import Foundation
class SoundItem {
    var soundID: String
    var engine: SoundEngine
    var isPlaying: Bool {
        player.isPlaying
    }

    var player: AVAudioPlayerNode
    var pitchController: AVAudioUnitVarispeed
    var file: AVAudioFile?
    // var mixer: AVAudioMixerNode
    var looping: Bool = false
    var pitch: Float {
        get {
            pitchController.rate
        }
        set {
            pitchController.rate = newValue
        }
    }

    var volume: Float {
        get {
            player.volume
        }
        set {
            player.volume = newValue
        }
    }

    var pan: Float {
        get {
            player.pan
        }
        set {
            player.pan = newValue
        }
    }

    var loop: Bool {
        set {
            if newValue {
                looping = true
            } else {
                looping = false
            }
        }
        get {
            looping
        }
    }

    var filename: String

    init!(_ fileName: String, _ engine: SoundEngine) {
        self.engine = engine
        soundID = UUID().uuidString
        filename = fileName
        // self.mixer = AVAudioMixerNode()
        do {
            let fileURL = Bundle.main.url(forResource: filename, withExtension: "m4a")
            file = try AVAudioFile(forReading: fileURL!)
            player = AVAudioPlayerNode()
            print("sound created")
        } catch {
            print("Error creating sound \(filename)")
            return nil
        }
        pitchController = AVAudioUnitVarispeed()
    }

    func replay() {
        player.stop()
        player.
            player.play()
    }

    func stop() {
        player.stop()
    }

    func checkNext() {
        if looping {
            player.scheduleFile(file!, at: nil) {
                self.checkNext()
            }
        }
    }

    func play() {
        player.scheduleFile(file!, at: nil) {
            self.checkNext()
        }
        player.play()
    }

    func destroy() {
        engine.engine.detach(player)
        engine.engine.detach(pitchController)
    }

    deinit {
        tts.speakVo("dead")
    }
}

class SoundEngine {
    var sounds: [SoundItem] = []
    var oneShotSounds: [SoundItem]
    var engine: AVAudioEngine
    init() {
        oneShotSounds = []
        engine = AVAudioEngine()
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
                self.engine.attach(sound.pitchController)
                print("attached")
                self.engine.connect(sound.player, to: sound.pitchController, format: nil)
                //		self.engine.connect(sound.player, to: self.engine.mainMixerNode, format: nil)
                self.engine.connect(sound.pitchController, to: self.engine.mainMixerNode, format: nil)
                print("all nodes connected.")
                if !self.engine.isRunning {
                    print("not running")
                    try self.engine.start()
                }
                print("scheduling file")
                // sound.player.scheduleFile(sound.file!, at: nil) {
                // }
                print("nodes connected")
            } catch {
                print("Error connecting nodes")
            }
        }
    }

    func create(_ filename: String) -> SoundItem? {
        let newSound = SoundItem(filename, self)
        print("connecting")
        connectNodes(newSound!)
        print("connected")
        return newSound
    }

    func playOnce(_ file: String) -> Int {
        let newSound = create(file)

        oneShotSounds.append(newSound!)
        newSound?.play()

        doAfter(newSound!.player.duration * 2) {
            self.removeOneShot(newSound!.soundID)
        }
        return newSound!.duration
    }

    func removeOneShot(_ id: String) {
        for index in 0 ..< oneShotSounds.count {
            if oneShotSounds[index].soundID == id {
                print("removing \(index), have \(oneShotSounds.count) items")
                oneShotSounds.remove(at: index)
                break
            }
        }
    }
}
