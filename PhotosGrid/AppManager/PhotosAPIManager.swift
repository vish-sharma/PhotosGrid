//
//  APIManager.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

class PhotosAPIManager: NSObject {
    
    /*
     * Method to handle URLSession - Data Task API calls
     */
    public func getDataFromUrl(strURL: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: strURL) else {
            LogsHandler.Error("URL is nil")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    /*
     * Method to invoke API Call and handle JSON Parsing
     * Completion handler passes PhotoModel Object, Error on completion of the call
     */
    public func getPhotosDataFromApi(page:Int, result: @escaping
        (PhotosModel?, Error?) -> Void ) {
        let urlString = "\(AppConstants.API_URL)\(page)\(AppConstants.CONSUMER_KEY)"
       
        
        getDataFromUrl(strURL: urlString) { (data, response, error) in
            guard error == nil else {
                LogsHandler.Error(error?.localizedDescription ?? "")
                return
            }
            
            guard let data = data as Data? else {
                LogsHandler.Error("Data Error")
                result(nil, error)
                return
            }
            
            //JSON String For Debugging purpose 
            
            if let jsonString = String(data: data, encoding: String.Encoding.utf8), error == nil {
                print(jsonString)
            } else {
                LogsHandler.Error(error?.localizedDescription ?? "")
            }
            
            //JSON Decoder to handle parsing and mapping to Model Class
            //PhotosModel
            do {
                //Parse JSON data and Save it in Model Class
                let decoder = JSONDecoder()
                let photosData = try decoder.decode(PhotosModel.self, from: data)
                result(photosData, nil)
            } catch let err {
                LogsHandler.Error("Parsing Error!")
                result(nil, err)
            }
        }
    }
    
    /*
     * Create Image Cache to hold Images - Prevents repeated downloads
     */
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    /*
     * Method to download image from URL String.
     * Completion handler passes UIImage, Error on completion of the call
     */
    func downloadImageFromURL(_ url: String, completion: @escaping
        (UIImage?, Error?) -> Void) {
        var photo = UIImage()
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            photo = imageFromCache
            completion(photo, nil)
            return
        }
        getDataFromUrl(strURL: url) { data, response, error in
            guard let data = data, error == nil else {
                LogsHandler.Error("Image Download failed")
                return
            }
            LogsHandler.Debug("Image Download Finished")
            
            //Hold image in Cache
            let imageToCache = UIImage(data: data)!
            self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
            
            photo = imageToCache
            completion(photo, nil)
        }
    }
}
