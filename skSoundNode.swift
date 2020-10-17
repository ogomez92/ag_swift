import SpriteKit

class SKSoundNode: SKNode {
	var sound: EngineItem?
	var width: CGFloat?
	var height: CGFloat?
	var panStep: CGFloat=0.008
	var pitchStep: CGFloat=0.0006
		var volStep: CGFloat=0.0006/2
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	init(_ filename: String, _ loop: Bool=true, width: CGFloat=0.0, height: CGFloat=0.0) {
		super.init()
		self.sound=engine.create(filename)
		self.width=width
		self.height=height

		self.sound?.loop=loop
self.sound?.play()
	}
 override func positionSound(_ lx: CGFloat, _ ly: CGFloat) {
	let width: CGFloat=self.width ?? 0.0
	let height: CGFloat=self.height ?? 0.0
		var sx=self.position.x
		var sy=self.position.y
	//process x
	if lx < self.position.x - width {
sx = sx - width
	}
	else if lx > self.position.x + width {
		sx = sx + width
	}

	else if lx < self.position.x && lx >= self.position.x-width{
sx=lx
	}
	else if lx > self.position.x && lx <= self.position.x+width{
		sx=lx
	}
	//process y
	if ly < self.position.y - height {
		sy = sy - height
	}
	else if ly > self.position.y + height {
		sy = sy + height
	}

	else if ly < self.position.y && ly >= self.position.y-height{
		sy=ly
	}
	else if ly > self.position.y && ly <= self.position.y+height{
		sy=ly
	}
		var dx: CGFloat=0
		var dy: CGFloat=0
		var finalVol: CGFloat=0
		var finalPan: CGFloat=0
		var finalPitch: CGFloat=1
 dx = sx-lx
dy = sy - ly
		let dya=abs(dy)
let dxa=abs(dx)
		finalVol -= (dxa * volStep)
			finalVol -= (dya * volStep)
		finalPan += (dx * panStep)
		finalPitch += (dy * pitchStep);
	finalVol=1.0
		if (finalVol < 0) {
			finalVol = 0;
		}
		if (finalPan < -1) {
			finalPan = -1;
		}
		if (finalPan > 1) {
			finalPan = 1;
		}
	print("positioning")
		self.sound?.volume=Float(finalVol)
		self.sound?.pan=Float(finalPan)
		self.sound?.pitch=Float(finalPitch)
	print("positioned")
		let playing = self.sound!.isPlaying
		if self.sound?.volume==0 && playing {
			self.sound?.stop()
		} else if finalVol > 0 && !playing {
			self.sound?.play()
			print("played")
		}
	}
	deinit {
		self.sound?.destroy()
		self.sound=nil
	}

}

extension SKNode {
	@objc func positionSound(_ lx: CGFloat, _ ly: CGFloat) {

	}
}
