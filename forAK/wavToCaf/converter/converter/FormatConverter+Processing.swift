// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

extension FormatConverter {
    // MARK: - private helper functions
    
    
    // Compressed input , PCM output
    // PCM input , PCM output
    
    
    // PCM output
    
    
    
    // Currently, as of 2017, if you want to convert from a compressed
    // format to a pcm one, you still have to hit CoreAudio
    internal func convertToPCM(completionHandler: FormatConverterCallback? = nil) {
        guard let inputURL = self.inputURL else {
            completionHandler?(createError(message: "Input file can't be nil."))
            return
        }
        guard let outputURL = self.outputURL else {
            completionHandler?(createError(message: "Output file can't be nil."))
            return
        }

        if isCompressed(url: outputURL) {
            completionHandler?(createError(message: "Output file must be PCM."))
            return
        }

        let inputFormat = inputURL.pathExtension.lowercased()
        let outputFormat = options?.format ?? outputURL.pathExtension.lowercased()

        print("convertToPCM() to \(outputURL)")

        var format: AudioFileTypeID
        let formatKey: AudioFormatID = kAudioFormatLinearPCM

        switch outputFormat {
        case "aif":
            format = kAudioFileAIFFType
        case "wav":
            format = kAudioFileWAVEType
        case "caf":
            format = kAudioFileCAFType
        default:
            completionHandler?(createError(message: "Output file must be caf, wav or aif."))
            return
        }

        var error = noErr
        var destinationFile: ExtAudioFileRef?
        var sourceFile: ExtAudioFileRef?

        var srcFormat = AudioStreamBasicDescription()
        var dstFormat = AudioStreamBasicDescription()

        error = ExtAudioFileOpenURL(inputURL as CFURL, &sourceFile)
        if error != noErr {
            completionHandler?(createError(message: "Unable to open the input file."))
            return
        }

        var thePropertySize = UInt32(MemoryLayout.stride(ofValue: srcFormat))

        guard let inputFile = sourceFile else {
            completionHandler?(createError(message: "Unable to open the input file."))
            return
        }

        error = ExtAudioFileGetProperty(inputFile,
                                        kExtAudioFileProperty_FileDataFormat,
                                        &thePropertySize, &srcFormat)

        if error != noErr {
            completionHandler?(createError(message: "Unable to get the input file data format."))
            return
        }
        let outputSampleRate = options?.sampleRate ?? srcFormat.mSampleRate
        let outputChannels = options?.channels ?? srcFormat.mChannelsPerFrame
        var outputBitRate = options?.bitDepth ?? srcFormat.mBitsPerChannel

        guard inputFormat != outputFormat ||
            outputSampleRate != srcFormat.mSampleRate ||
            outputChannels != srcFormat.mChannelsPerFrame ||
            outputBitRate != srcFormat.mBitsPerChannel else {
            print("No conversion is needed, formats are the same. Copying to", outputURL)
            // just copy it?
            do {
                try FileManager.default.copyItem(at: inputURL, to: outputURL)
                completionHandler?(nil)
            } catch let err as NSError {
                print(err)
            }
            return
        }

        var outputBytesPerFrame = outputBitRate * outputChannels / 8
        var outputBytesPerPacket = options?.bitDepth == nil ? srcFormat.mBytesPerPacket : outputBytesPerFrame

        // outputBitRate == 0 : in the input file this indicates a compressed format such as mp3
        if outputBitRate == 0 {
            outputBitRate = 16
            outputBytesPerPacket = 2 * outputChannels
            outputBytesPerFrame = 2 * outputChannels
        }

        dstFormat.mSampleRate = outputSampleRate
        dstFormat.mFormatID = formatKey
        dstFormat.mChannelsPerFrame = outputChannels
        dstFormat.mBitsPerChannel = outputBitRate
        dstFormat.mBytesPerPacket = outputBytesPerPacket
        dstFormat.mBytesPerFrame = outputBytesPerFrame
        dstFormat.mFramesPerPacket = 1
        dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger

        if format == kAudioFileAIFFType {
            dstFormat.mFormatFlags = dstFormat.mFormatFlags | kLinearPCMFormatFlagIsBigEndian
        }

        if format == kAudioFileWAVEType && dstFormat.mBitsPerChannel == 8 {
            // if is 8 BIT PER CHANNEL, remove kAudioFormatFlagIsSignedInteger
            dstFormat.mFormatFlags &= ~kAudioFormatFlagIsSignedInteger
        }

        // Create destination file
        error = ExtAudioFileCreateWithURL(outputURL as CFURL,
                                          format,
                                          &dstFormat,
                                          nil,
                                          AudioFileFlags.eraseFile.rawValue, // overwrite old file if present
                                          &destinationFile)

        if error != noErr {
            completionHandler?(createError(message: "Unable to create output file."))
            return
        }

        guard let outputFile = destinationFile else {
            completionHandler?(createError(message: "Unable to create output file (2)."))
            return
        }

        // 这一行代码，真神来之笔
        error = ExtAudioFileSetProperty(inputFile,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        if error != noErr {
            completionHandler?(createError(message: "Unable to set （ data format on output file.） "))
            return
        }

        error = ExtAudioFileSetProperty(outputFile,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        if error != noErr {
            completionHandler?(createError(message: "Unable to set （ the output file data format.） "))
            return
        }
        let bufferByteSize: UInt32 = 32_768
        var srcBuffer = [UInt8](repeating: 0, count: Int(bufferByteSize))
        var sourceFrameOffset: UInt32 = 0

        srcBuffer.withUnsafeMutableBytes { ptr in
            while true {
                let mBuffer = AudioBuffer(mNumberChannels: srcFormat.mChannelsPerFrame,
                                          mDataByteSize: bufferByteSize,
                                          mData: ptr.baseAddress)

                var fillBufList = AudioBufferList(mNumberBuffers: 1, mBuffers: mBuffer)
                var numFrames: UInt32 = 0

                if dstFormat.mBytesPerFrame > 0 {
                    numFrames = bufferByteSize / dstFormat.mBytesPerFrame
                }

                error = ExtAudioFileRead(inputFile, &numFrames, &fillBufList)
                if error != noErr {
                    completionHandler?(createError(message: "Unable to read input file."))
                    return
                }
                if numFrames == 0 {
                    error = noErr
                    break
                }

                sourceFrameOffset += numFrames

                error = ExtAudioFileWrite(outputFile, numFrames, &fillBufList)
                if error != noErr {
                    completionHandler?(createError(message: "Unable to write output file."))
                    return
                }
            }
        }

        error = ExtAudioFileDispose(outputFile)
        if error != noErr {
            completionHandler?(createError(message: "Unable to dispose the output file object."))
            return
        }

        error = ExtAudioFileDispose(inputFile)
        if error != noErr {
            completionHandler?(createError(message: "Unable to dispose the input file object."))
            return
        }

        completionHandler?(nil)
    }

    internal func isCompressed(url: URL) -> Bool {
        // NOTE: account for files that don't have extensions
        let ext = url.pathExtension.lowercased()
        return (ext == "m4a" || ext == "mp3" || ext == "mp4" || ext == "m4v" || ext == "mpg")
    }

    internal func createError(message: String, code: Int = 1) -> NSError {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: message]
        return NSError(domain: "io.audiokit.FormatConverter.error", code: code, userInfo: userInfo)
    }
}