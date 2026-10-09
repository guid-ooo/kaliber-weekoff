import CoreMIDI
import Foundation

struct MIDINote {
    let channel: UInt8
    let note: UInt8
    let velocity: UInt8
    let isOn: Bool
}

final class MIDIListener {
    private var client = MIDIClientRef()
    private var port = MIDIPortRef()

    var onNote: ((MIDINote) -> Void)?
    private(set) var sourceCount = 0

    func start() {
        let notify: MIDINotifyBlock = { [weak self] _ in
            DispatchQueue.main.async { self?.connectAll() }
        }
        guard MIDIClientCreateWithBlock("WeekOffBridge" as CFString, &client, notify) == noErr else { return }
        guard MIDIInputPortCreateWithProtocol(client, "In" as CFString, ._1_0, &port, { [weak self] list, _ in
            self?.handle(list)
        }) == noErr else { return }
        connectAll()
    }

    private func connectAll() {
        let count = MIDIGetNumberOfSources()
        for index in 0..<count {
            MIDIPortConnectSource(port, MIDIGetSource(index), nil)
        }
        sourceCount = count
    }

    private func handle(_ list: UnsafePointer<MIDIEventList>) {
        for packet in list.unsafeSequence() {
            for word in UnsafePointer(packet).words() {
                guard let note = Self.decode(word) else { continue }
                DispatchQueue.main.async { self.onNote?(note) }
            }
        }
    }

    static func decode(_ word: UInt32) -> MIDINote? {
        guard UInt8((word >> 28) & 0xF) == 0x2 else { return nil }
        let status = UInt8((word >> 20) & 0xF)
        let channel = UInt8((word >> 16) & 0xF)
        let data1 = UInt8((word >> 8) & 0x7F)
        let data2 = UInt8(word & 0x7F)
        switch status {
        case 0x9: return MIDINote(channel: channel, note: data1, velocity: data2, isOn: data2 > 0)
        case 0x8: return MIDINote(channel: channel, note: data1, velocity: 0, isOn: false)
        default: return nil
        }
    }
}
