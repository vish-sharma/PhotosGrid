//
//  PhotoGridViewModel.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

/*
 * View Model class handling interaction between View Controllers and Model object.
 * VCs synch up with View Model class to talk with APIManager, Model
 */

class PhotoGridViewModel: NSObject {
    
    //MARK:Properties
    var apiManager: PhotosAPIManager
    var photosData: PhotosModel?
    var photosArray: [PhotosData]? = []
    
    override init() {
        self.apiManager = PhotosAPIManager()
     }

    // MARK: Service call
    
    /*
     * Method to invoke API call to fetch Photos Data. Manages PhotosArray
     * with each pagination.
     * Compeltion handler pass Bool, Error
     */
    func getPhotosData(pageCount:Int, completion: @escaping
        (Bool?, Error?) -> Void ) {
        
        guard let apiManager = apiManager as PhotosAPIManager? else {
            LogsHandler.Error("API Manager is Nil")
            return
        }
        
        //Invoke API call
        apiManager.getPhotosDataFromApi(page: pageCount) {(result, error) in
            if result?.photos != nil {
                self.photosData = result
                
                //Append the Photo Modal Object to Photos Array
                if let resultPhotos = result?.photos {
                    for photoObj in resultPhotos {
                        self.photosArray?.append(photoObj)
                    }
                }
                
                //Completion Handler
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    /*
     * Method to invoke API call to download images for Cell Indexpath.
     * Compeltion handler pass downloaded Image to cell,or Error
     */
    func getPhotoForIndex(_ index:Int, completion:
        @escaping (UIImage?, Error?) -> Void)  {
        
        if self.photosArray != nil {
            if let photosArr: [PhotosData] = self.photosArray {
                for i in 0..<photosArr.count {
                    if i == index {
                         //images[0] returns Size 3 images
                        let imageUrl = photosArr[i].images[0].url
                       
                        //Download Photo for the cell index
                        getPhotoFromURL(imageUrl, completion: { (downloadedPhoto, error) in
                            completion(downloadedPhoto, error)
                        })
                    }
                }
            }
        }
    }
    
    /*
     * Method to invoke API call to download images from URL String.
     * Compeltion handler pass downloaded Image, Error
     */
    func getPhotoFromURL (_ urlStr: String, completion:
        @escaping (UIImage?, Error?) -> Void) {
        apiManager.downloadImageFromURL(urlStr) { (downloadedPhoto, error) in
            completion(downloadedPhoto, error)
        }
    }
    
    /*
     * Method to fetch Photos Data from the Array based upon provided IndexPath
     * Returns PhotosData Object
     */
    func getPhotoDetailsAtIndex(_ index: Int) -> PhotosData? {
        if let photosArr: [PhotosData] = self.photosArray {
            for i in 0..<photosArr.count {
                if i == index {
                    let indexObj = photosArr[i]
                    return indexObj
                }
            }
        }
        return nil
    }
}
