//
//  ViewController.swift
//  PhotosGrid
//
//  Created by Vishal on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

class PhotosHomeViewController: UIViewController {
    
    var viewModel: PhotoGridViewModel!
    @IBOutlet weak var apiCallButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View Model Instance
        viewModel = PhotoGridViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     * Button IBAction to invoke API call to download images for Cell Indexpath.
     */
    @IBAction func invokeAPICallAction(_ sender: Any) {
        apiCallButton.isUserInteractionEnabled = false
        viewModel.getPhotosData(pageCount: 1) { (succees, error) in
            if succees == true {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:AppConstants.StoryBoard.PhotosGridSegue, sender: self)
                }
            } else {
                LogsHandler.Error("Err - Service Failed")
            }
        }
    }
    
     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AppConstants.StoryBoard.PhotosGridSegue) {
            if let destinationVC = segue.destination as? PhotosGridViewController  {
                //Pass ViewModel Instance to GridVC
                destinationVC.viewModel = viewModel
                apiCallButton.isUserInteractionEnabled = true
            }
        }
     }
 
    
}

