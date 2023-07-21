//
//  Profile.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 20.07.2023.
//

import Foundation

struct Profile: Codable {
    let username, name, loginName: String
    let bio: String?

    init(decodedData: ProfileResult) {
        self.username = decodedData.username
        self.name = (decodedData.firstName ) + " " + (decodedData.lastName )
        self.loginName = "@" + (decodedData.username )
        self.bio = decodedData.bio
    }
}
