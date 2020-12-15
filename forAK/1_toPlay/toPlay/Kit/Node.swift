// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation


/// 2D array of stereo audio data
public typealias FloatChannelData = [[Float]]


/// AudioKIt connection point
open class Node {
    /// Nodes providing input to this node.
    open var connections: [Node] = []

    /// The internal AVAudioEngine AVAudioNode
    open var avAudioNode: AVAudioNode

    /// The internal AVAudioUnit, which is a subclass of AVAudioNode with more capabilities
    open var avAudioUnit: AVAudioUnit? {
        didSet {
            guard let avAudioUnit = avAudioUnit else { return }

            let mirror = Mirror(reflecting: self)

            for child in mirror.children {
                if let param = child.value as? ParameterBase, let label = child.label {
                    // Property wrappers create a variable with an underscore
                    // prepended. Drop the underscore to look up the parameter.
                    let name = String(label.dropFirst())
                    param.projectedValue.associate(with: avAudioUnit,
                                                   identifier: name)
                }
            }
        }
    }

    /// Returns either the avAudioUnit or avAudioNode (prefers the avAudioUnit if it exists)
    open var avAudioUnitOrNode: AVAudioNode {
        return avAudioUnit ?? avAudioNode
    }

    /// Initialize the node from an AVAudioUnit
    /// - Parameter avAudioUnit: AVAudioUnit to initialize with
    public init(avAudioUnit: AVAudioUnit) {
        self.avAudioUnit = avAudioUnit
        self.avAudioNode = avAudioUnit
    }

    /// Initialize the node from an AVAudioNode
    /// - Parameter avAudioNode: AVAudioNode to initialize with
    public init(avAudioNode: AVAudioNode) {
        self.avAudioNode = avAudioNode
    }

    /// Reset the internal state of the unit
    /// Fixes issues such as https://github.com/AudioKit/AudioKit/issues/2046
    public func reset() {
        if let avAudioUnit = self.avAudioUnit {
            AudioUnitReset(avAudioUnit.audioUnit, kAudioUnitScope_Global, 0)
        }
    }

    func detach() {
        if let engine = avAudioNode.engine {
            engine.detach(avAudioNode)
        }
        for connection in connections {
            connection.detach()
        }
    }

    func makeAVConnections() {
        // Are we attached?
        if let engine = avAudioNode.engine {
            for (bus, connection) in connections.enumerated() {
                if let sourceEngine = connection.avAudioNode.engine {
                    if sourceEngine != avAudioNode.engine {
                        print("🛑 Error: Attempt to connect nodes from different engines.")
                        return
                    }
                }

                engine.attach(connection.avAudioNode)

                // Mixers will decide which input bus to use.
                if let mixer = avAudioNode as? AVAudioMixerNode {
                    mixer.connect(input: connection.avAudioNode, bus: mixer.nextAvailableInputBus)
                } else {
                    avAudioNode.connect(input: connection.avAudioNode, bus: bus)
                }

                connection.makeAVConnections()
            }
        }
    }

    /// Work-around for an AVAudioEngine bug.
    func initLastRenderTime() {

        // We don't have a valid lastRenderTime until we query it.
        _ = avAudioNode.lastRenderTime

        for connection in connections {
            connection.initLastRenderTime()
        }
    }
}




/// Protocol for dictating that a node can be in a started or stopped state
public protocol Toggleable {
    /// Tells whether the node is processing (ie. started, playing, or active)
    var isStarted: Bool { get }

    /// Function to start, play, or activate the node, all do the same thing
    func start()

    /// Function to stop or bypass the node, both are equivalent
    func stop()
}




/// Default functions for nodes that conform to Toggleable
public extension Toggleable {
    /// Synonym for isStarted that may make more sense with musical instruments
    var isPlaying: Bool {
        return isStarted
    }

    /// Antonym for isStarted
    var isStopped: Bool {
        return !isStarted
    }

    /// Antonym for isStarted that may make more sense with effects
    var isBypassed: Bool {
        return !isStarted
    }

    /// Synonym to start that may more more sense with musical instruments
    func play() {
        start()
    }

    /// Synonym for stop that may make more sense with effects
    func bypass() {
        stop()
    }
}


