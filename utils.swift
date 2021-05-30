import Foundation
extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()

            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion()
                }
            }
        }
    }
}

func repeatAction(_ times: Int, _ ms: Int, what: @escaping () -> Void) {
    var currentTime: Int = 0
    for _ in stride(from: 0, to: times, by: 1) {
        currentTime += ms
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(currentTime / 1000)) {
            what()
        }
    }
}

func doAfter(_ ms: Int, what: @escaping () -> Void) {
    let timer = Timer(timeInterval: Double(ms) / 1000, repeats: false, block: { _ in
        what()
    })
    timer.tolerance = 0
    RunLoop.current.add(timer, forMode: .common)
}

func loc(_ what: String, _ param1: String = "", _ param2: String = "", _ param3: String = "", _ param4: String = "", _ param5: String = "") -> String {
    let str = NSLocalizedString(what, comment: "hi")
    let wantedString = String(format: str, param1, param2, param3, param4, param5)
    return wantedString
}

func getProportion(current: Double, min: Double, max: Double, minDesired: Double, maxDesired: Double) -> Double {
    // print("current: \(current), min: \(min), max: \(max)")
    if current >= max {
        return maxDesired
    }
    if current <= min {
        return minDesired
    }
    if max == 0 { return maxDesired }
    return (current / (min + max)) * (maxDesired - minDesired) + minDesired
}
