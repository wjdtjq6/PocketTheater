//
//  NetworkManager.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/9/24.
//

import Foundation

enum MediaType: String {
    case tv, movie
}

enum NetworkError: Error {
    case invalidURL, invalidResponse, invalidData, unknown
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // URLRequest 생성 함수
    private func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            Header.Authorization.rawValue: APIKey.key,
            "accept": Header.accept.rawValue
        ]
        return request
    }
    
    // Decodable 데이터 요청 함수
    private func fetchDecodableRequest<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: makeRequest(for: url))
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error:", error)
            throw NetworkError.invalidData
        }
    }
    
    // Data 요청 함수
    private func fetchDataRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: makeRequest(for: url))
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
    // API URL 생성 함수
    private func makeURL(path: String, queryItems: [URLQueryItem], isImageURL: Bool = false) throws -> URL {
        let baseURL = isImageURL ? APIKey.imageURL : APIKey.baseURL
        var components = URLComponents(string: baseURL + path)
        if !isImageURL {
            var allQueryItems = queryItems
            allQueryItems.append(URLQueryItem(name: "language", value: "ko-KR"))
            components?.queryItems = allQueryItems
        }
        guard let url = components?.url else { throw NetworkError.invalidURL }
        return url
    }
    
    func fetchTrending(mediaType: MediaType) async throws -> Media {
        let url = try makeURL(path: "trending/\(mediaType.rawValue)/week", queryItems: [])
        return try await fetchDecodableRequest(url: url)
    }
    
    func searchMedia(mediaType: MediaType, query: String, page: Int) async throws -> Media {
        let url = try makeURL(path: "search/\(mediaType.rawValue)", queryItems: [URLQueryItem(name: "query", value: query),
                                                                                 URLQueryItem(name: "page", value: "\(page)")])
        return try await fetchDecodableRequest(url: url)
    }
    
    func fetchSimilar(mediaType: MediaType, id: Int) async throws -> Media {
        let url = try makeURL(path: "\(mediaType.rawValue)/\(id)/recommendations", queryItems: [])
        return try await fetchDecodableRequest(url: url)
    }
    
    func fetchCast(mediaType: MediaType, id: Int) async throws -> Cast {
        let url = try makeURL(path: "\(mediaType.rawValue)/\(id)/credits", queryItems: [])
        return try await fetchDecodableRequest(url: url)
    }
    
    func fetchGenre(mediaType: MediaType) async throws -> Genre {
        let url = try makeURL(path: "genre/\(mediaType.rawValue)/list", queryItems: [])
        return try await fetchDecodableRequest(url: url)
    }
    
    func fetchImage(imagePath: String) async throws -> Data {
        let url = try makeURL(path: imagePath, queryItems: [], isImageURL: true)
        return try await fetchDataRequest(url: url)
    }
}
