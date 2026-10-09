import AVFoundation
import Accelerate

final class SamplePlayer {
    private let engine = AVAudioEngine()
    private let lock = NSLock()
    private var voices: [String: Voice] = [:]
    private var scene: Voice?
    private var sceneKey: String?

    private struct Voice {
        let node: AVAudioPlayerNode
        let buffer: AVAudioPCMBuffer
        let gain: Float
    }

    static let targetRMS: Float = 0.12
    static let maxGain: Float = 8
    static let minGain: Float = 0.1
    static let softestVelocityVolume: Float = 0.15

    static func volume(forVelocity velocity: UInt8) -> Float {
        let scale = Float(min(velocity, 127)) / 127
        return softestVelocityVolume + (1 - softestVelocityVolume) * scale
    }

    static func normalizationGain(for buffer: AVAudioPCMBuffer) -> Float {
        guard let channels = buffer.floatChannelData else { return 1 }
        let frames = vDSP_Length(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)
        guard frames > 0, channelCount > 0 else { return 1 }

        var meanSquare: Float = 0
        var peak: Float = 0
        for channel in 0..<channelCount {
            var rms: Float = 0
            vDSP_rmsqv(channels[channel], 1, &rms, frames)
            meanSquare += rms * rms
            var channelPeak: Float = 0
            vDSP_maxmgv(channels[channel], 1, &channelPeak, frames)
            peak = max(peak, channelPeak)
        }
        let rms = (meanSquare / Float(channelCount)).squareRoot()
        guard rms > 0.0001, peak > 0.0001 else { return 1 }
        return min(max(min(targetRMS / rms, 0.98 / peak), minGain), maxGain)
    }

    func start() {
        _ = engine.mainMixerNode
        engine.prepare()
        try? engine.start()
    }

    private func makeVoice(_ path: String) -> Voice? {
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        guard let file = try? AVAudioFile(forReading: url), file.length > 0 else { return nil }
        let format = file.processingFormat
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)),
              (try? file.read(into: buffer)) != nil else { return nil }
        let node = AVAudioPlayerNode()
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        return Voice(node: node, buffer: buffer, gain: Self.normalizationGain(for: buffer))
    }

    @discardableResult
    func preload(_ path: String) -> Bool {
        if lock.withLock({ voices[path] != nil }) { return true }
        guard let voice = makeVoice(path) else { return false }
        lock.withLock { voices[path] = voice }
        return true
    }

    func play(_ path: String, velocity: UInt8 = 127) {
        guard preload(path), let voice = lock.withLock({ voices[path] }) else { return }
        if !engine.isRunning { try? engine.start() }
        voice.node.stop()
        voice.node.volume = min(max(Self.volume(forVelocity: velocity) * voice.gain, 0), 1)
        voice.node.scheduleBuffer(voice.buffer, at: nil, completionHandler: nil)
        voice.node.play()
    }

    func playScene(_ path: String?, fade: Double) {
        if sceneKey == path { return }
        stopScene(fade: fade)
        sceneKey = path
        guard let path, let voice = makeVoice(path) else { return }
        if !engine.isRunning { try? engine.start() }
        scene = voice
        voice.node.volume = 0
        voice.node.scheduleBuffer(voice.buffer, at: nil, completionHandler: nil)
        voice.node.play()
        ramp(voice.node, to: min(voice.gain, 1), over: fade)
    }

    func stopScene(fade: Double) {
        guard let voice = scene else { return }
        scene = nil
        ramp(voice.node, to: 0, over: fade) { [weak self] in
            voice.node.stop()
            self?.engine.disconnectNodeOutput(voice.node)
            self?.engine.detach(voice.node)
        }
    }

    private func ramp(_ node: AVAudioPlayerNode, to target: Float, over seconds: Double, then: (() -> Void)? = nil) {
        let steps = max(Int(seconds * 40), 1)
        let start = node.volume
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds * Double(step) / Double(steps)) {
                node.volume = start + (target - start) * Float(step) / Float(steps)
                if step == steps { then?() }
            }
        }
    }
}
