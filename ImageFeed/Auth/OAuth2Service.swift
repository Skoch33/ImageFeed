//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.06.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    let urlSession = URLSession.shared
    
    private(set) var authToken: String? {
        get {
            return OAuth2TokenStorage.token
        }
        set {
            OAuth2TokenStorage.token = newValue
        }
    }
    
    private enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request = authTokenRequest(code: code)
        let task = self.object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.access_token
                self.authToken = authToken
                DispatchQueue.main.async {
                    completion(.success(authToken))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let response = response as? HTTPURLResponse,
               200 ..< 300 ~= response.statusCode {
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(responseBody))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError.urlSessionError))
            }
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        let parameters = [
            "client_id": AccessKey,
            "client_secret": SecretKey,
            "redirect_uri": RedirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        return request
    }
}
