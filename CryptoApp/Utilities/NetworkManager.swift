//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 7/1/24.
//

import Combine
import Foundation

class NetworkManager {
    
    enum NetworkError : LocalizedError {
        case badURLResponse(url : URL)
        case unknown
        
        var errorDescription: String?{
            switch self {
            case .badURLResponse(url : let url):
                return "Bad response from response from - \(url)"
            case .unknown:
                return "Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleUrlResponse(url: url,output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static func handleUrlResponse(url : URL,output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }

    static func handleCompletation(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
