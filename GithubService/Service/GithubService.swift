//
//  GithubService.swift
//  GithubService
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import Combine

public protocol GithubServiceType {
    func getRepositories( request: GetRepositoriesRequestModel) -> AnyPublisher <GithubModel, GithubService.Error>
}

final public class GithubService {
    
    // MARK: - Properties
    /// Session
    fileprivate let session: URLSession
    
    /// A shared JSON decoder to use in calls.
    private let decoder = JSONDecoder()
    
    /// Session Queue
    private let apiQueue = DispatchQueue(label: "GithubService", qos: .default, attributes: .concurrent)
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// MARK: Network Errors.
    public enum Error: LocalizedError, Identifiable {
        public var id: String { localizedDescription }
        
        case unknownNetwork
        case networkResponse(NSError)
        case addressUnreachable(URL)
        case invalidResponse
        case decoding
        
        public var errorDescription: String? {
            switch self {
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            case .invalidResponse: return "The server responded with garbage."
            case .decoding: return "Some decoding error occured"
            case .networkResponse(let error): return error.localizedDescription
            case .unknownNetwork: return "Some unknown network error occured"
            }
        }
    }
    
    /// MARK: Network endpoints.
    private enum EndPoint {
        
        case repositories(request: GetRepositoriesRequestModel)
        
        var url: URL {
            switch self {
            case .repositories(let request):
                return prepareGetRequestUrlComponenets(request: request).url!
            }
        }
        
        private var baseSearchComponent: URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/repositories"
            return components
        }
        
        private func prepareGetRequestUrlComponenets(request: GetRepositoriesRequestModel) -> URLComponents {
            let items = ["q": request.query,
                         "sort": request.sort.rawValue,
                         "order": request.order.rawValue,
                         "page": String(request.page),
                         "per_page": String(request.per_page)]
            var components = baseSearchComponent
            components.setQueryItems(with: items)
            return components
        }
    }
}

extension GithubService: GithubServiceType {
    
    public func getRepositories( request: GetRepositoriesRequestModel) -> AnyPublisher <GithubModel, GithubService.Error> {
        return session.dataTaskPublisher(for: GithubService.EndPoint.repositories(request: request).url)
            .receive(on: apiQueue)
            .tryMap { data, response -> Data in
                let httpResponse = response as? HTTPURLResponse
                if let httpResponse = httpResponse, 200..<399 ~= httpResponse.statusCode {
                    return data
                }
                else if let httpResponse = httpResponse {
                    let nserror = NSError(domain: httpResponse.description, code: httpResponse.statusCode, userInfo: httpResponse.allHeaderFields as? [String : Any])
                    throw GithubService.Error.networkResponse(nserror)
                }     else {
                    throw GithubService.Error.unknownNetwork
                }
        }
        .decode(type: GithubModel.self, decoder: decoder)
        .mapError { error in
            switch error {
            case is URLError:
                return Error.addressUnreachable(GithubService.EndPoint.repositories(request: request).url)
            case is DecodingError:
                return Error.decoding
            default:
                return Error.invalidResponse
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
}

fileprivate extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
