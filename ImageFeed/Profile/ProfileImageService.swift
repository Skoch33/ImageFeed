//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 12.06.2023.
//

import UIKit

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var getProfileImageTask: URLSessionTask?
    private let storageToken = OAuth2TokenStorage()
    private (set) var avatarURL: String?
    
    
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
    
    struct ProfileImage: Codable {
        let profileImage: [String:String]

        init(decodedData: UserResult) {
            self.profileImage = decodedData.profileImage
        }
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        let request = makeProfileImageRequest(token: storageToken.token!, username: username)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let decodedObject):
                let avatarURL = ProfileImage(decodedData: decodedObject)
                self.avatarURL = avatarURL.profileImage["large"]
                completion(.success(self.avatarURL!))
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.getProfileImageTask = task
        task.resume()
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
