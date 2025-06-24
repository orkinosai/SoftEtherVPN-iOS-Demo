import Foundation

public class SoftEtherVPNClient {
    private let vpnProtocol: SoftEtherProtocol
    private let host: String
    private let port: UInt16

    public init(host: String, port: UInt16) {
        self.host = host
        self.port = port
        self.vpnProtocol = SoftEtherProtocol()
    }

    public func connect(completion: @escaping (Bool, Error?) -> Void) {
        vpnProtocol.connect(to: host, port: port) { [weak self] success, error in
            if success {
                // Connection was successful
                completion(true, nil)
            } else {
                // Handle connection failure
                completion(false, error)
            }
        }
    }

    public func disconnect() {
        vpnProtocol.disconnect()
    }

    // Add other methods as needed
}