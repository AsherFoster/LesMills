import Foundation
import Get
import Security
import KeychainAccess

enum Paths {}

// This client is a wrapper around Get, based on the JellyfinClient from JellyfinAPI
public final class LesMillsClient {
    static let apiBase = URL(string: "https://appservices.lesmills.co.nz/1.6")!
    
    public private(set) var apiToken: UUID?
    
    private var _apiClient: APIClient!
    private let delegate: APIClientDelegate?
    
    public init(
        delegate: APIClientDelegate? = nil,
        apiToken: UUID? = nil
    ) {
        self.apiToken = apiToken
        self.delegate = delegate
        
        self._apiClient = APIClient(baseURL: LesMillsClient.apiBase) { configuration in
            configuration.delegate = self
            
//            configuration.sessionConfiguration = sessionConfiguration
//            configuration.sessionDelegate = sessionDelegate
//
//            let isoDateFormatter: DateFormatter = OpenISO8601DateFormatter()
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
//            configuration.decoder = decoder
//
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .formatted(isoDateFormatter)
//            encoder.outputFormatting = .prettyPrinted
//            configuration.encoder = encoder
        }
    }
    
    public func send<T>(
        _ request: Request<T>,
        delegate: URLSessionDataDelegate? = nil,
        configure: ((inout URLRequest) throws -> Void)? = nil
    ) async throws -> Response<T> where T: Decodable {
        try await _apiClient.send(request, delegate: delegate, configure: configure)
    }

    @discardableResult
    public func send(
        _ request: Request<Void>,
        delegate: URLSessionDataDelegate? = nil,
        configure: ((inout URLRequest) throws -> Void)? = nil
    ) async throws -> Response<Void> {
        try await _apiClient.send(request, delegate: delegate, configure: configure)
    }
}

extension LesMillsClient: APIClientDelegate {
    public func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        if let apiToken {
            request.addValue(apiToken.uuidString, forHTTPHeaderField: "LMNZ.Authorisation")
        }

        try await delegate?.client(_apiClient, willSendRequest: &request)
    }
    
    public func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        if let delegate = delegate {
            try delegate.client(_apiClient, validateResponse: response, data: data, task: task)
        } else {
#if DEBUG
            print("\(response.statusCode): \(response.url != nil ? response.url!.absoluteString : "no URL")")
#endif
            guard (200 ..< 300).contains(response.statusCode) else {
#if DEBUG
                print(String(data: data, encoding: .utf8)!)
#endif
                throw APIError.unacceptableStatusCode(response.statusCode)
            }
        }
    }

    public func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool {
        try await delegate?.client(_apiClient, shouldRetry: task, error: error, attempts: attempts) ?? false
    }

    public func client<T>(_ client: APIClient, makeURLForRequest request: Request<T>) throws -> URL? {
        try delegate?.client(_apiClient, makeURLForRequest: request)
    }
}


extension LesMillsClient {
    static let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    static let tokenKeyName = "token"

    private func saveTokenToStorage(token: UUID) throws {
#if DEBUG
        print("saveTokenToStorage", token.uuidString)
#endif
        
        LesMillsClient.keychain[LesMillsClient.tokenKeyName] = token.uuidString
    }
    
    private func readTokenFromStorage() throws -> UUID? {
        if let token = try? LesMillsClient.keychain.get(LesMillsClient.tokenKeyName) {
#if DEBUG
            print("readTokenFromStorage", token)
#endif
            if let uuid = UUID(uuidString: token) {
                return uuid
            } else {
                print("Failed to parse token, nuking")
                removeTokenFromStorage()
            }
        }
        return nil
    }
    
    private func removeTokenFromStorage() {
        LesMillsClient.keychain[LesMillsClient.tokenKeyName] = nil
    }
    
    @discardableResult
    func signInFromStorage() async throws -> UserProfile? {
        apiToken = try readTokenFromStorage()
        if apiToken == nil {
            return nil
        }
        
        do {
            let request = Paths.getDetails()
            return try await send(request).value.contactDetails
        } catch APIError.unacceptableStatusCode(let statusCode) {
            // Les Mills will return an Internal Server Error for invalid UUIDs, and 401 for bad tokens
            if statusCode == 401 || statusCode == 500 {
                // The status code is most likely bad and we should log out
                try signOut()
            }
        }
        
        // This is unexpected, TODO handle
        return nil
    }
    
    func signIn(memberId: String, password: String) async throws -> SignInResponse {
        let signInRequest = Paths.signIn(memberId: memberId, password: password)
        let response = try await send(signInRequest).value
        
        let token = response.contactDetails.apiToken
        try saveTokenToStorage(token: token)
        apiToken = token
        
        return response
    }
    
    func signOut() throws {
        removeTokenFromStorage()
        apiToken = nil
    }
}
