//
//  PhotosModel.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

/*
 * Modal Class mapped to API Service call
 * Using Decodable Protocol to handle mapping with JSON response
 */

struct PhotosModel: Decodable {
    let photos: [PhotosData]
}

struct PhotosData: Decodable {
    let times_viewed: Int
    let votes_count: Int
    let images: [ImageData]
    let image_url : [String]
    let user : UserDetails
    let description: String?
}

struct ImageData: Decodable {
    let size: Int
    let url: String
}

struct UserDetails: Decodable {
    let firstname: String?
    let lastname: String?
    let avatars: UserImage
}

struct UserImage: Decodable {
    let large: AvatarUrl
}

struct AvatarUrl: Decodable {
    let https: String
}
