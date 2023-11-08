//
//  LesMillsClient.swift
//  LesMills
//
//  Created by Asher Foster on 26/10/23.
//

import Foundation
import Get

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
            print(response)
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
    func signIn(memberId: String, password: String) async throws -> SignInResponse {
        let signInRequest = Paths.signIn(memberId: memberId, password: password)
        let response = try await send(signInRequest).value
        
        apiToken = response.contactDetails.apiToken
        
        return response
    }
    
    func signOut() async throws {
        // Do something server-side?
        apiToken = nil
    }
}
