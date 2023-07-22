//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 20.07.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username, firstName, lastName: String
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        
    }
}
