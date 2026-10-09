import AppKit

final class EmojiOverlay {
    private var vensters: [NSWindow] = []

    func toon(_ emoji: String, seconden: Double = 1.6) {
        guard !emoji.isEmpty else { return }
        for scherm in NSScreen.screens {
            let label = NSTextField(labelWithString: emoji)
            label.font = .systemFont(ofSize: min(scherm.frame.height * 0.34, 420))
            label.alignment = .center
            label.backgroundColor = .clear
            label.isBezeled = false
            label.isEditable = false
            label.sizeToFit()

            let venster = NSWindow(contentRect: scherm.frame, styleMask: .borderless, backing: .buffered, defer: false)
            venster.isOpaque = false
            venster.backgroundColor = .clear
            venster.hasShadow = false
            venster.ignoresMouseEvents = true
            venster.level = .init(Int(CGWindowLevelForKey(.maximumWindow)))
            venster.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
            venster.setFrame(scherm.frame, display: false)

            let houder = NSView(frame: NSRect(origin: .zero, size: scherm.frame.size))
            label.frame.origin = NSPoint(x: (houder.frame.width - label.frame.width) / 2,
                                         y: (houder.frame.height - label.frame.height) / 2)
            houder.addSubview(label)
            venster.contentView = houder
            venster.alphaValue = 0
            venster.orderFrontRegardless()
            vensters.append(venster)

            label.wantsLayer = true
            label.layer?.setAffineTransform(CGAffineTransform(scaleX: 0.7, y: 0.7))

            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.18
                venster.animator().alphaValue = 1
                label.layer?.setAffineTransform(.identity)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + seconden) { [weak self] in
                NSAnimationContext.runAnimationGroup({ ctx in
                    ctx.duration = 0.35
                    venster.animator().alphaValue = 0
                }, completionHandler: {
                    venster.orderOut(nil)
                    self?.vensters.removeAll { $0 === venster }
                })
            }
        }
    }
}
