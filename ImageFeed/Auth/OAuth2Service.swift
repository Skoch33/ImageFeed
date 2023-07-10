//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 2.06.2023.
//

import Foundation

final class OAuth2Service {
    enum NetworkError: Error {
        case codeError
        case unableToDecodeStringFromData
    }
    
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        guard let request = makeRequest(code: code) else { return }
        
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            self.currentTask = nil
            switch result {
            case .success(let oAuthToken):
                handler(.success(oAuthToken.access_token))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        currentTask?.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "\(Constants.baseURL)")!
        )}
}

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = Constants.defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
