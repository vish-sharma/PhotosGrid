//
//  PhotosGridTests.swift
//  PhotosGridTests
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import XCTest
@testable import PhotosGrid

class PhotosGridTests: XCTestCase {
    
    let photoViewModel = PhotoGridViewModel()
    var expectation = XCTestExpectation()
    
    override func setUp() {
        super.setUp()
         let exp = expectation(description: "API Expectation")
        
        //Test - Api Service Call
        //Given more time - Use OCMock/Stub responses to Unit test Service call
        photoViewModel.getPhotosData(pageCount: 1) { (success, error) in
            if success == true {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //Test - Valid Photo data
    func testViewModelClassCaseA() {
        let photoArray = photoViewModel.photosArray!.count
        XCTAssertNotNil(photoArray, "Err - Photo array is empty!")
        XCTAssertTrue(photoViewModel.photosArray!.count > 0, "Err- Array is empty!")
    }
    
    func testViewModelClassCaseB() {
        let exp = expectation(description: "Image Expectation")
        photoViewModel.getPhotoForIndex(1) { (image, error) in
            exp.fulfill()
            XCTAssertNotNil(image, "Err - Image is not available!")
            XCTAssertTrue(error == nil, "No Error occurred..")
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    //Test - Valid Photo data
    func testViewModelClassCaseC() {
        let photoObject = photoViewModel.getPhotoDetailsAtIndex(1)
        XCTAssertNotNil(photoObject, "Err - Photo object not fetched!")
    }
    
    //Test - Valid Photo data
    func testViewModelClassCaseD() {
        let photoObject = photoViewModel.getPhotoDetailsAtIndex(1)
        XCTAssertNotNil(photoObject?.images, "Err - Image array is empty!")
        XCTAssertNotNil(photoObject?.user, "Err- User details are empty!")
        XCTAssertNotNil(photoObject?.times_viewed, "Err- View count is empty!")
        XCTAssertNotNil(photoObject?.votes_count, "Err- Votes count is empty!")
    }
    
}
