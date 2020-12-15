// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

extension AVAudioNode {
    /// Disconnect and manage engine connections
    public func disconnect(input: AVAudioNode) {
        if let engine = engine {
            for bus in 0 ..< numberOfInputs {
                if let cp = engine.inputConnectionPoint(for: self, inputBus: bus) {
                    if cp.node === input {
                        engine.disconnectNodeInput(self, bus: bus)
                    }
                }
            }
        }
    }

    /// Make a connection without breaking other connections.
    public func connect(input: AVAudioNode, bus: Int, format: AVAudioFormat? = Settings.audioFormat) {
        if let engine = engine {
            var points = engine.outputConnectionPoints(for: input, outputBus: 0)
            if points.contains(where: { $0.node === self }) { return }
            points.append(AVAudioConnectionPoint(node: self, bus: bus))
            engine.connect(input, to: points, fromBus: 0, format: format)
        }
    }
}

/// AudioKit's wrapper for AVAudioEngine
public class AudioEngine {
    /// Internal AVAudioEngine
    public let avEngine = AVAudioEngine()

    // maximum number of frames the engine will be asked to render in any single render call
    let maximumFrameCount: AVAudioFrameCount = 1_024

    public private(set) var mainMixerNode: Mixer?

    /// Input node mixer
    public class InputNode: Mixer {
        var isNotConnected = true

        func connect(to engine: AudioEngine) {
            engine.avEngine.attach(avAudioNode)
            engine.avEngine.connect(engine.avEngine.inputNode, to: avAudioNode, format: nil)
        }
    }

    let _input = InputNode()

    /// Input for microphone or other device is created when this is accessed
    public var input: InputNode? {
        if #available(macOS 10.14, *) {
            guard Bundle.main.object(forInfoDictionaryKey: "NSMicrophoneUsageDescription") != nil else {
                print("To use the microphone, you must include the NSMicrophoneUsageDescription in your Info.plist")
                return nil
            }
        }
        if _input.isNotConnected {
            _input.connect(to: self)
            _input.isNotConnected = false
        }
        return _input
    }

    /// Empty initializer
    public init() {}

    /// Output node
    public var output: Node? {
        didSet {
            // AVAudioEngine doesn't allow the outputNode to be changed while the engine is running
            let wasRunning = avEngine.isRunning
            if wasRunning { stop() }

            // remove the exisiting node if it is present
            if let node = oldValue {
                mainMixerNode?.removeInput(node)
                node.detach()
                avEngine.outputNode.disconnect(input: node.avAudioNode)
            }

            // if non nil, set the main output now
            if let node = output {
                avEngine.attach(node.avAudioNode)

                // has the sample rate changed?
                if let currentSampleRate = mainMixerNode?.avAudioUnitOrNode.outputFormat(forBus: 0).sampleRate,
                    currentSampleRate != Settings.sampleRate {
                    print("Sample Rate has changed, creating new mainMixerNode at", Settings.sampleRate)
                    removeEngineMixer()
                }

                // create the on demand mixer if needed
                createEngineMixer()
                mainMixerNode?.addInput(node)
                mainMixerNode?.makeAVConnections()
            }

            if wasRunning { try? start() }
        }
    }

    // simulate the AVAudioEngine.mainMixerNode, but create it ourselves to ensure the
    // correct sample rate is used from Settings.audioFormat
    private func createEngineMixer() {
        guard mainMixerNode == nil else { return }

        let mixer = Mixer()
        avEngine.attach(mixer.avAudioNode)
        avEngine.connect(mixer.avAudioNode, to: avEngine.outputNode, format: Settings.audioFormat)
        mainMixerNode = mixer
    }

    private func removeEngineMixer() {
        guard let mixer = mainMixerNode else { return }
        avEngine.outputNode.disconnect(input: mixer.avAudioNode)
        mixer.removeAllInputs()
        mixer.detach()
        mainMixerNode = nil
    }

    /// Start the engine
    public func start() throws {
        if output == nil {
            print("🛑 Error: Attempt to start engine with no output.")
            return
        }
        try avEngine.start()
    }

    /// Stop the engine
    public func stop() {
        avEngine.stop()
    }

   




}
