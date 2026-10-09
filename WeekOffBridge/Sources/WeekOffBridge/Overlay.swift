import AppKit
import QuartzCore

final class EmojiOverlay {
    private var vensters: [NSWindow] = []

    func toon(_ emoji: String, seconden: Double = 1.8) {
        guard !emoji.isEmpty else { return }
        if let bestand = NotoEmoji.bestand(voor: emoji), let film = NotoEmoji.frames(bestand) {
            toonFilm(film, seconden: seconden)
            return
        }
        NotoEmoji.haalOp(emoji) { [weak self] url in
            guard let self else { return }
            if let url, let film = NotoEmoji.frames(url) { self.toonFilm(film, seconden: seconden) }
            else { self.toonTekst(emoji, seconden: seconden) }
        }
    }

    private func toonFilm(_ film: (beelden: [CGImage], duur: Double), seconden: Double) {
        for scherm in NSScreen.screens {
            let zijde = min(scherm.frame.height * 0.22, 260)
            let marge: CGFloat = 56
            let kader = NSRect(x: scherm.frame.minX + scherm.frame.width - zijde - marge,
                               y: scherm.frame.minY + marge,
                               width: zijde, height: zijde + 110)

            let venster = maakVenster(kader)
            let houder = NSView(frame: NSRect(origin: .zero, size: kader.size))
            houder.wantsLayer = true
            venster.contentView = houder
            venster.orderFrontRegardless()
            vensters.append(venster)

            let laag = CALayer()
            laag.frame = CGRect(x: 0, y: 0, width: zijde, height: zijde)
            laag.contentsGravity = .resizeAspect
            laag.contents = film.beelden.first
            houder.layer?.addSublayer(laag)

            let frames = CAKeyframeAnimation(keyPath: "contents")
            frames.values = film.beelden
            frames.duration = film.duur
            frames.calculationMode = .discrete
            frames.repeatCount = .greatestFiniteMagnitude
            laag.add(frames, forKey: "frames")

            let omhoog = CABasicAnimation(keyPath: "position.y")
            omhoog.fromValue = laag.position.y
            omhoog.toValue = laag.position.y + 90
            omhoog.duration = seconden
            omhoog.timingFunction = CAMediaTimingFunction(name: .easeOut)

            let vervagen = CAKeyframeAnimation(keyPath: "opacity")
            vervagen.values = [0, 1, 1, 0]
            vervagen.keyTimes = [0, 0.1, 0.68, 1]
            vervagen.duration = seconden

            let groep = CAAnimationGroup()
            groep.animations = [omhoog, vervagen]
            groep.duration = seconden
            groep.fillMode = .forwards
            groep.isRemovedOnCompletion = false
            laag.add(groep, forKey: "beweging")

            DispatchQueue.main.asyncAfter(deadline: .now() + seconden) { [weak self] in
                venster.orderOut(nil)
                self?.vensters.removeAll { $0 === venster }
            }
        }
    }

    private func maakVenster(_ kader: NSRect) -> NSWindow {
        let venster = NSWindow(contentRect: kader, styleMask: .borderless, backing: .buffered, defer: false)
        venster.isOpaque = false
        venster.backgroundColor = .clear
        venster.hasShadow = false
        venster.ignoresMouseEvents = true
        venster.level = .init(Int(CGWindowLevelForKey(.maximumWindow)))
        venster.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        return venster
    }

    private func toonTekst(_ emoji: String, seconden: Double) {
        for scherm in NSScreen.screens {
            let grootte = min(scherm.frame.height * 0.16, 190)
            let label = NSTextField(labelWithString: emoji)
            label.font = .systemFont(ofSize: grootte)
            label.backgroundColor = .clear
            label.isBezeled = false
            label.isEditable = false
            label.sizeToFit()

            let marge: CGFloat = 56
            let kader = NSRect(x: scherm.frame.width - label.frame.width - marge,
                               y: marge,
                               width: label.frame.width,
                               height: label.frame.height + 140)

            let venster = NSWindow(contentRect: NSRect(origin: NSPoint(x: scherm.frame.minX + kader.minX,
                                                                       y: scherm.frame.minY + kader.minY),
                                                       size: kader.size),
                                   styleMask: .borderless, backing: .buffered, defer: false)
            venster.isOpaque = false
            venster.backgroundColor = .clear
            venster.hasShadow = false
            venster.ignoresMouseEvents = true
            venster.level = .init(Int(CGWindowLevelForKey(.maximumWindow)))
            venster.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]

            let houder = NSView(frame: NSRect(origin: .zero, size: kader.size))
            houder.wantsLayer = true
            label.frame.origin = NSPoint(x: 0, y: 0)
            label.wantsLayer = true
            houder.addSubview(label)
            venster.contentView = houder
            venster.orderFrontRegardless()
            vensters.append(venster)

            guard let laag = label.layer else { continue }
            laag.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            laag.position = CGPoint(x: label.frame.width / 2, y: label.frame.height / 2)

            let pop = CAKeyframeAnimation(keyPath: "transform.scale")
            pop.values = [0.3, 1.18, 1.0, 1.0, 0.92]
            pop.keyTimes = [0, 0.14, 0.26, 0.72, 1]
            pop.duration = seconden
            pop.timingFunction = CAMediaTimingFunction(name: .easeOut)

            let omhoog = CABasicAnimation(keyPath: "position.y")
            omhoog.fromValue = laag.position.y
            omhoog.toValue = laag.position.y + 120
            omhoog.duration = seconden
            omhoog.timingFunction = CAMediaTimingFunction(name: .easeOut)

            let wiebel = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            wiebel.values = [-0.16, 0.10, -0.05, 0.02, 0]
            wiebel.keyTimes = [0, 0.2, 0.45, 0.7, 1]
            wiebel.duration = seconden

            let vervagen = CAKeyframeAnimation(keyPath: "opacity")
            vervagen.values = [0, 1, 1, 0]
            vervagen.keyTimes = [0, 0.12, 0.62, 1]
            vervagen.duration = seconden

            let groep = CAAnimationGroup()
            groep.animations = [pop, omhoog, wiebel, vervagen]
            groep.duration = seconden
            groep.fillMode = .forwards
            groep.isRemovedOnCompletion = false
            laag.add(groep, forKey: "emoji")

            DispatchQueue.main.asyncAfter(deadline: .now() + seconden) { [weak self] in
                venster.orderOut(nil)
                self?.vensters.removeAll { $0 === venster }
            }
        }
    }
}
