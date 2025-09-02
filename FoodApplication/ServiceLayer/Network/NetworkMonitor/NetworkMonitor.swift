import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private(set) var isConnected = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
