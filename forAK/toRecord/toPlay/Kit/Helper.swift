//
//  Helper.swift
//  toPlay
//
//  Created by Jz D on 2020/12/15.
//

import Foundation
import AVFoundation

public typealias AUValue = Float





/// Base protocol for any type supported by @Parameter
public protocol NodeParameterType {
    /// Get the float value
    func toAUValue() -> AUValue
    /// Initialize with a floating point number
    /// - Parameter value: initial value
    init(_ value: AUValue)
}




/// NodeParameter wraps AUParameter in a user-friendly interface and adds some AudioKit-specific functionality.
/// New version for use with Parameter property wrapper.
public class NodeParameter {
    private var avAudioUnit: AVAudioUnit!

    /// AU Parameter that this wraps
    public private(set) var parameter: AUParameter!

    // MARK: Parameter properties

    /// Value of the parameter
    public var value: AUValue {
        get { parameter.value }
        set { parameter.value = range.clamp(newValue) }
    }

    /// Boolean values for parameters
    public var boolValue: Bool {
        get { value > 0.5 }
        set { value = newValue ? 1.0 : 0.0 }
    }

    /// Minimum value
    public var minValue: AUValue {
        parameter.minValue
    }

    /// Maximum value
    public var maxValue: AUValue {
        parameter.maxValue
    }

    /// Value range
    public var range: ClosedRange<AUValue> {
        (parameter.minValue ... parameter.maxValue)
    }

    // MARK: Automation

    private var renderObserverToken: Int?

 
    /// Stop automation
    public func stopAutomation() {
        if let token = renderObserverToken {
            avAudioUnit.auAudioUnit.removeRenderObserver(token)
        }
    }

    private var parameterObserverToken: AUParameterObserverToken?


    // MARK: Lifecycle

    /// This function should be called from Node subclasses as soon as a valid AU is obtained
    public func associate(with avAudioUnit: AVAudioUnit, identifier: String) {
        self.avAudioUnit = avAudioUnit
        parameter = avAudioUnit.auAudioUnit.parameterTree?[identifier]
        assert(parameter != nil)
    }
    
}





/// Used internally so we can iterate over parameters using reflection.
protocol ParameterBase {
    var projectedValue: NodeParameter { get }
}

/// Wraps NodeParameter so we can easily assign values to it.
///
/// Instead of`osc.frequency.value = 440`, we have `osc.frequency = 440`
///
/// Use the $ operator to access the underlying NodeParameter. For example:
/// `osc.$frequency.maxValue`
///
/// When writing an Node, use:
/// ```
/// @Parameter var myParameterName: AUValue
/// ```
/// This syntax gives us additional flexibility for how parameters are implemented internally.
///
/// Note that we don't allow initialization of Parameters to values
/// because we don't yet have an underlying AUParameter.
@propertyWrapper
public struct Parameter<Value: NodeParameterType>: ParameterBase {
    var param = NodeParameter()

    /// Empty initializer
    public init() {}

    /// Get the wrapped value
    public var wrappedValue: Value {
        get { Value(param.value) }
        set { param.value = newValue.toAUValue() }
    }

    /// Get the projected value
    public var projectedValue: NodeParameter {
        get { param }
        set { param = newValue }
    }
}




extension AUParameterTree {
    /// Look up paramters by key
    public subscript(key: String) -> AUParameter? {
        return value(forKey: key) as? AUParameter
    }
}
