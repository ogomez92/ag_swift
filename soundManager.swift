import AVFoundation
import Foundation

class SoundItem {
    var soundID: String
    var player: AVAudioPlayer

    var file: AVAudioFile?
    var volume: Float {
        get {
            player.volume
        }
        set {
            player.volume = newValue
        }
    }

    var duration: Int {
        Int(player.duration * 1000)
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
        get {
            player.numberOfLoops == 0 ? false : true
        }
        set {
            if !newValue { player.numberOfLoops = 0 }
            if newValue { player.numberOfLoops = -1 }
        }
    }

    var filename: String
    init!(_ fileName: String) {
        filename = fileName
        soundID = UUID().uuidString
        //			print(self.filename)
        let fileURL = Bundle.main.url(forResource: filename, withExtension: "m4a")
        // print("loaded file for "+self.filename)
        player = try! AVAudioPlayer(contentsOf: fileURL!)
        player.prepareToPlay()
    }

    func checkNext() {}

    func playAnd(_ what: @escaping () -> Void) {
        player.play()
        doAfter(Int(duration)) {
            what()
        }
    }

    func fadeIn(_: Int) {}

    func play() {
        player.play()
    }

    func stop() {
        player.stop()
    }

    func replay() {
        player.stop()
        player.currentTime = 0
        player.play()
    }

    func pause() {
        player.pause()
    }

    func fade() {
        player.setVolume(0.0, fadeDuration: 1.5)
    }
}

class SoundManager {
    var oneShotSounds: [SoundItem]
    var sounds: [SoundItem] = []
    init() {
        oneShotSounds = []
    }

    func create(_ filename: String) -> SoundItem? {
        if let snd = SoundItem(filename) {
            return snd
        } else {
            print("Cannot create sound item in sound manager for \(filename)")
        }
        return nil
    }

    func playOnce(_ file: String) -> Int {
        let newSound = create(file)

        oneShotSounds.append(newSound!)
        newSound?.play()

        doAfter(newSound!.duration * 2) {
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
