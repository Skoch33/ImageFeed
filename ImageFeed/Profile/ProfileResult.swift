//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 12.06.2023.
//

import UIKit

struct ProfileResult: Codable {
    let username: String
    let first_name: String?
    let last_name: String?
    let bio: String?
}
