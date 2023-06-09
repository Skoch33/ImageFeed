//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 12.06.2023.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    private (set) var avatarURL: URL?
    private var getProfileImageTask: URLSessionTask?
    private let storageToken = OAuth2TokenStorage()
    private var lastProfileImageCode: String?
    let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    private enum GetProfileImageError: Error {
        case profileImageCodeError
        case unableToDecodeStringFromProfileImageData
        case noURL
    }
    
    struct UserResult: Codable {
        let profileImage: [String: String]
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<URL, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeProfileImageRequest(token: storageToken.token!, username: username)
        
        let session = URLSession.shared
        getProfileImageTask = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            self.getProfileImageTask = nil
            switch result {
            case .success(let userResult):
                guard let avatarStringURL = userResult.profileImage["large"],
                      let avatarURL = URL(string: avatarStringURL) else {
                    completion(.failure(GetProfileImageError.noURL))
                    return
                }
                self.avatarURL = avatarURL
                NotificationCenter.default.post(name: self.DidChangeNotification, object: nil)
                completion(.success(avatarURL))
            case .failure(_):
                completion(.failure(GetProfileImageError.unableToDecodeStringFromProfileImageData))
                self.lastProfileImageCode = nil
                return
            }
        }
        getProfileImageTask?.resume()
    }
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest {
        var request = URLRequest(url: Constants.defaultBaseURL.appendingPathComponent("users/\(username)"))
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func clean() {
        avatarURL = nil
        getProfileImageTask?.cancel()
        getProfileImageTask = nil
    }
}
