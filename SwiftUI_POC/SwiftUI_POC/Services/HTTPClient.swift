//
//  HTTPClient.swift
//  SwiftUI_POC
//
//  Created by Abdul Jaleel, Jefin (Cognizant) on 04/11/22.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

class HTTPClient {
    
    func getArticles() async -> AnyPublisher<[Article], NetworkError> {
        guard let url = URL(string: Constants.articleUrl) else {
            preconditionFailure(NetworkError.badURL.localizedDescription)
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.noData }
            .map(\.data)
            .decode(type: [Article].self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .eraseToAnyPublisher()
    }
}
