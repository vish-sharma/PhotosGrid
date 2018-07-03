//
//  PhotosViewController.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

class PhotosGridViewController: UIViewController, UICollectionViewDelegate {
   
    // MARK: IBOutlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingStackTopConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    let photosArray :[String] = ["1","2","3","4","5","6","7","8"]
    var viewModel: PhotoGridViewModel?
    var pageCount: Int!
    var selectedPhotoData: PhotosData?
    var selectedCell = PhotosCollectionViewCell()
    
    //Handles Custom Animation of the ModalVC
    let transition = CustomGridTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializw pageCount = 2 as page 1 is already fetched from API call
        pageCount = 2
        
        //Register cell Xib with View Controller
        self.photosCollectionView.register(UINib(nibName:"PhotosCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"PhotosCollectionViewCell" )
        
        loadingStackTopConstraint.constant += 100
        
        //Custom Animation for Details ModalVC
        transition.dismissCompletion = {
            self.selectedCell.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AppConstants.StoryBoard.PhotoDetailsSegue) {
            if let destinationVC = segue.destination as? PhotosDetailViewController  {
                //Pass Selected Photo Details to DetailsVC
                destinationVC.photoData = self.selectedPhotoData
                destinationVC.viewModel = self.viewModel
                destinationVC.transitioningDelegate = self
            }
        }
    }
}

extension PhotosGridViewController: UICollectionViewDataSource {
    //MARK : CollectionView DataSource
    
    /*
     * Method returns number of Items based upon Photos Array count
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrayCount = self.viewModel?.photosArray?.count {
            return arrayCount
        }
        return 1
    }
    
    /*
     * Method to Collection View - cellForItem, handles downloading of images
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CellIdentifers.GridCellIdentifier, for: indexPath) as! PhotosCollectionViewCell
        
        cell.backgroundColor = UIColor.lightGray
        //Download Image from Response
        viewModel?.getPhotoForIndex(indexPath.row, completion: { (downloadedPhoto, error) in
            
            //Load Photos in UIImageView on Main Thread
            DispatchQueue.main.async() {
                if downloadedPhoto != nil {
                    cell.loadPhoto(photo: downloadedPhoto!) }
                else {
                    //Erro - Load Placeholder Image 
                    cell.loadPhoto(photo: UIImage(named: "placeholder")!)
                    LogsHandler.Error("Photo Unavailable!")
                }
            }
        })
        return cell
    }
    
    /*
     * Method to handle Pagination, Invoke API Call to load more data
     */
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Checking for Indexpath
        if indexPath.row + 1 == (self.viewModel?.photosArray?.count) {
            
            loadingStackTopConstraint.constant -= 50
            activityIndicator.startAnimating()
            self.view.bringSubview(toFront: loadingStackView)
            
            //Invoke API Call to fetch more data
            viewModel?.getPhotosData(pageCount: pageCount, completion: { (success, error) in
                if success == true  {
                    //Main Thread to handle UI updates
                    DispatchQueue.main.async() {
                        self.activityIndicator.stopAnimating()
                        self.view.sendSubview(toBack: self.loadingStackView)
                        self.loadingStackTopConstraint.constant += 50
                        self.photosCollectionView .reloadData()

                        //Reload only Visible items to avoid flickering
                        //self.photosCollectionView.reloadItems(at: self.photosCollectionView .indexPathsForVisibleItems)
                    }
                    //Increment page count to load next API call
                    self.pageCount! += 1
                }
            })
        }
    }
    
    /*
     * Method to handle DidSelect CollectionView Cell
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        
        //Fetch indexed data from ViewModel
        if let selectedImageData: PhotosData = viewModel?.getPhotoDetailsAtIndex(indexPath.row) {
            self.selectedPhotoData = selectedImageData
            DispatchQueue.main.async {
                self.performSegue(withIdentifier:AppConstants.StoryBoard.PhotoDetailsSegue, sender: self)
            }
        }
    }
}

extension PhotosGridViewController: UICollectionViewDelegateFlowLayout {

    /*
     * Method to handle Collection View Layout. HARDCODED.
     * Given more time - I would have tried to layout dynamically based upon Photo size.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numberOfColumns, width :CGFloat
        numberOfColumns = 2
        width = self.photosCollectionView.frame.size.width
        
//        return CGSize(width: width/numberOfColumns - cellSpacing, height: width/2 - cellSpacing)
         return CGSize(width: width/numberOfColumns, height: width/2)
    }
}

extension PhotosGridViewController: UIViewControllerTransitioningDelegate {
    
    /*
     * Method to handle presentation of Details ModelVC
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let originFrame = selectedCell.superview?.convert((selectedCell.frame), to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        selectedCell.isHidden = true
        return transition
    }
    
    /*
     * Method to handle dismissal of Details ModelVC
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
