import libc

public enum ErrorReason {
    case createSocketFailed
    case optionSetFailed(level: Int32, name: Int32, value: String)
    case optionGetFailed(level: Int32, name: Int32, type: String)
    case closeSocketFailed
    
    case pipeCreationFailed
    
    case selectFailed(
        reads: [Int32],
        writes: [Int32],
        errors: [Int32]
    )
    
    case localAddressResolutionFailed
    case remoteAddressResolutionFailed
    case ipAddressResolutionFailed
    case ipAddressValidationFailed(String)
    case failedToGetIPFromHostname(String)
    case unparsableBytes
    
    case connectFailed
    case connectFailedWithSocketErrorCode(Int32)
    case connectTimedOut
    case sendFailedToSendAllBytes
    case readFailed
    case bindFailed
    case listenFailed
    case acceptFailed
    
    case unsupportedSocketAddressFamily(Int32)
    case concreteSocketAddressFamilyRequired
    
    case socketIsClosed
    
    case generic(String)
}

public struct SocketsError: Error, CustomStringConvertible {
    
    public let type: ErrorReason
    public let number: Int32
    
    init(_ type: ErrorReason) {
        self.type = type
        self.number = errno //last reported error code
    }
    
    init(message: String) {
        self.type = .generic(message)
        self.number = -1
    }
    
    func getReason() -> String {
        let reason = String(validatingUTF8: strerror(number)) ?? "?"
        return reason
    }
    
    public var description: String {
        return "Socket failed with code \(self.number) (\"\(getReason())\") [\(self.type)]"
    }

    public static let interruptedSystemCall: Int32 = EINTR
}
