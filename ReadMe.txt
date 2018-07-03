Project - PhotosGrid 

The code is designed using MVVM Design pattern. View-Controllers are kept light- weight and free of business logics

Class Structure is as following:

View Controllers – PhotosHomeViewController, PhotosGridViewController, PhotosDetailViewController
View Models – PhotoGridViewModel
Model – PhotosModel
View – PhotosCollectionViewCell, CustomGridTransition

Other Classes – 
Manager – PhotosAPIManager
Helper – AppConstants, LogsHandler

ViewModel is used extensively to handle Service call and to create synch between Controllers and Model classes. PhotosAPIManager handles the Service calls. 

XCTest includes the methodology to test the asynch network call and check the ViewModel Class methods.

Known Issues: 
1. Collection View Layout is not exactly as per the 500px app. 
2. ActivityIndicator position should be in Collection View Footer
 


