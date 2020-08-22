import Foundation


	func doAFter(_ ms: Int, what: () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + Float(ms/1000)) {
what()
		}
}
