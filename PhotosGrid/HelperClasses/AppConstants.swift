//
//  AppConstants.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import Foundation

//App contstant
struct AppConstants {
    
    static let API_URL = "https://api.500px.com/v1/photos?feature=popular&image_size[]=3&image_size[]=4&page="
    
    static let CONSUMER_KEY = "&consumer_key=P7LLhKkPAnPUpbfAXk3Jq2iDjYmCx87zgfEDxQVS"
    
    //Storyboard Keys
    struct StoryBoard {
        static let PhotosGridSegue = "PhotosGridSegue"
        static let PhotoDetailsSegue = "PhotoDetailsSegue"
    }
    
    //Reuse cell identifier keys
    struct CellIdentifers {
        static let GridCellIdentifier = "PhotosCollectionViewCell"
    }
    
    struct StaticUIText {
        static let Views = "views"
        static let PeopleVoted = "people voted this photo"
        static let AlertTitle = "More Details"
        static let NoDescription = "No description available!"
        static let OkButtonText = "Ok"
    }
}
