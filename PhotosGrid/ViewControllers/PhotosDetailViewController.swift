//
//  PhotosDetailViewController.swift
//  PhotosGrid
//
//  Created by Omm on 7/2/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var photoData: PhotosData?
    var viewModel: PhotoGridViewModel?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var votesCountLabel: UILabel!
    
    // define a variable to store initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Fetch Photo Data from Modal Object
        //Add default values for Error Handling scenarios
        let userFirstName = photoData?.user.firstname ?? ""
        let userLastName = photoData?.user.lastname ?? ""
        let viewsCount = photoData?.times_viewed ?? 0
        let votesCount = photoData?.votes_count ?? 0
        
        //Download Full Size Image
        viewModel?.getPhotoFromURL((photoData?.images[1].url)!, completion: { (downloadedPhoto, error) in
             DispatchQueue.main.async() {
                if downloadedPhoto != nil {
                    self.imageView.image = downloadedPhoto
                }
            }
        })
        
        //Download User Avatar
        viewModel?.getPhotoFromURL((photoData?.user.avatars.large.https)!, completion: { (downloadedPhoto, error) in
            DispatchQueue.main.async() {
                if downloadedPhoto != nil {
                    self.userAvatar.image = downloadedPhoto
                    self.userAvatar.layer.cornerRadius = 20.0
                    self.userAvatar.layer.masksToBounds = true
                    
                    self.userLabel.text = userFirstName + " " + userLastName
                    self.viewsCountLabel.text = "\(viewsCount) " + AppConstants.StaticUIText.Views
                    self.votesCountLabel.text = "\(votesCount) " + AppConstants.StaticUIText.PeopleVoted
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Method to handle Close button Action
     */
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     * Method to handle Pan Gesture to Dismiss VC
     */
    @IBAction func panGestureAction(_ sender: AnyObject) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    /*
     * Method to show Alert controller with more details on Photo
     * Given more time - I would have designed screen as per 500px App
     */
    @IBAction func moreDetailsButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: AppConstants.StaticUIText.AlertTitle, message: (photoData?.description ?? AppConstants.StaticUIText.NoDescription) , preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: AppConstants.StaticUIText.OkButtonText, style: .default) { (action:UIAlertAction) in
            print("Ok");
        }
        
        alertController.addAction(action1)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
