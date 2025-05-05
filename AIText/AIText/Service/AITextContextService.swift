import Foundation
import AppKit

class AITextContextService: NSObject {
    static let shared = AITextContextService()
    
    func registerServices() {
        let application = NSApplication.shared
        application.servicesProvider = self
    }
    
    @objc func processText(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        guard let string = pboard.string(forType: .string),
              !string.isEmpty,
              let uuid = UUID(uuidString: userData) else {
            return
        }
        
        Task {
            await MainActor.run {
                ContextMenuManager.shared.executeMenuItemAction(uuid: uuid, text: string)
            }
        }
    }
} 
