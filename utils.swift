import Foundation

func doAfter(_ ms: Int, what: @escaping() -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + Double(ms/1000)) {
		what()
	}
}

func loc(_ what: String, _ param1: String="", _ param2: String="", _ param3: String="", _ param4: String="", _ param5: String="")-> String {
	let str = NSLocalizedString(what, comment: "hi")
	let wantedString = String(format: str, param1, param2, param3, param4, param5)
	return wantedString
}
