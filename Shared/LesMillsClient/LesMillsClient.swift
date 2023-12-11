//
//  LesMillsClient.swift
//  LesMills
//
//  Created by Asher Foster on 26/10/23.
//

import Foundation
import Get
import Security

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
    static let keychainKeyName = "LES_MILLS_API_TOKEN"
    
    private func saveTokenToStorage(token: UUID) throws {
        #if DEBUG
        print("saveTokenToStorage", token.uuidString)
        #endif
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: LesMillsClient.keychainKeyName,
            kSecValueData as String: Data(token.uuidString.utf8),
            kSecAttrAccessible as String:
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw APIError.unacceptableStatusCode(500) // TODO make an actual error
        }
    }
    
    private func readTokenFromStorage() throws -> UUID? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: LesMillsClient.keychainKeyName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue as Any
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw APIError.unacceptableStatusCode(500) // TODO make an actual error
        }
        
        #if DEBUG
        print("readTokenFromStorage", String(data: dataTypeRef as! Data, encoding: .utf8)!)
        #endif
        
        guard
            let data = dataTypeRef as? Data,
            let dataStr = String(data: data, encoding: .utf8),
            let uuid = UUID(uuidString: dataStr)
        else {
            throw APIError.unacceptableStatusCode(500) // TODO make an actual error
        }
        
        return uuid
    }
    
    private func removeTokenFromStorage() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: LesMillsClient.keychainKeyName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue as Any
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw APIError.unacceptableStatusCode(500) // TODO make an actual error
        }
    }
    
    @discardableResult
    func signInFromStorage() throws -> Bool {
        apiToken = try readTokenFromStorage()
        return apiToken != nil
    }
    
    func signIn(memberId: String, password: String) async throws -> SignInResponse {
        let signInRequest = Paths.signIn(memberId: memberId, password: password)
        let response = try await send(signInRequest).value
        
        #if DEBUG
        print("signIn response", response)
        #endif
        
        let token = response.contactDetails.apiToken
        try saveTokenToStorage(token: token)
        apiToken = token
        
        return response
    }
    
    func signOut() async throws {
        try removeTokenFromStorage()
        apiToken = nil
    }
}