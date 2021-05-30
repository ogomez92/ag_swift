import SpriteKit

class SKSoundNode: SKNode {
    var sound: EngineItem?
    var width: CGFloat?
    var height: CGFloat?
    var panStep: CGFloat = 0.008
    var pitchStep: CGFloat = 0.0006
    var volStep: CGFloat = 0.0006 / 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ filename: String, _ loop: Bool = true, width: CGFloat = 0.0, height: CGFloat = 0.0) {
        super.init()
        sound = engine.create(filename)
        self.width = width
        self.height = height

        sound?.loop = loop
        sound?.play()
    }

    override func positionSound(_ lx: CGFloat, _ ly: CGFloat) {
        let width: CGFloat = self.width ?? 0.0
        let height: CGFloat = self.height ?? 0.0
        var sx = position.x
        var sy = position.y
        // process x
        if lx < position.x - width {
            sx = sx - width
        } else if lx > position.x + width {
            sx = sx + width
        } else if lx < position.x, lx >= position.x - width {
            sx = lx
        } else if lx > position.x, lx <= position.x + width {
            sx = lx
        }
        // process y
        if ly < position.y - height {
            sy = sy - height
        } else if ly > position.y + height {
            sy = sy + height
        } else if ly < position.y, ly >= position.y - height {
            sy = ly
        } else if ly > position.y, ly <= position.y + height {
            sy = ly
        }
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        var finalVol: CGFloat = 0
        var finalPan: CGFloat = 0
        var finalPitch: CGFloat = 1
        dx = sx - lx
        dy = sy - ly
        let dya = abs(dy)
        let dxa = abs(dx)
        finalVol -= (dxa * volStep)
        finalVol -= (dya * volStep)
        finalPan += (dx * panStep)
        finalPitch += (dy * pitchStep)
        finalVol = 1.0
        if finalVol < 0 {
            finalVol = 0
        }
        if finalPan < -1 {
            finalPan = -1
        }
        if finalPan > 1 {
            finalPan = 1
        }
        print("positioning")
        sound?.volume = Float(finalVol)
        sound?.pan = Float(finalPan)
        sound?.pitch = Float(finalPitch)
        print("positioned")
        let playing = sound!.isPlaying
        if sound?.volume == 0, playing {
            sound?.stop()
        } else if finalVol > 0, !playing {
            sound?.play()
            print("played")
        }
    }

    deinit {
        self.sound?.destroy()
        self.sound = nil
    }
}

extension SKNode {
    @objc func positionSound(_: CGFloat, _: CGFloat) {}
}
