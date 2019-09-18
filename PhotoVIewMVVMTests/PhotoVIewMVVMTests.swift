//
//  PhotoVIewMVVMTests.swift
//  PhotoVIewMVVMTests
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import XCTest
@testable import PhotoVIewMVVM

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

class PhotoVIewMVVMTests: XCTestCase {
    var expectation: XCTestExpectation?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewModel(){
        
        let viewModel = PhotoCollectionViewModel()
        
        // Do any additional setup after loading the view.
        XCTAssertNoThrow(viewModel.reloadCollectionViewCompletion)
        XCTAssertNoThrow(viewModel.loadingStatus)
        XCTAssertNoThrow(viewModel.photoSearchBootstrap())
        
    }
    
    func testGetPhotos() {
        let expectation: XCTestExpectation = self.expectation(description: "get photos")
        let apiClient: APIClientService! = APIClientService()
        
        try! apiClient.downloadSearchResultsForPhotos(complete: { (photo, response) in
            XCTAssertNotNil(photo, "PhotoSearch array is nil") //response data is not nil
            XCTAssertTrue(photo!.count > 1)
            expectation.fulfill()
        }, failure: { (err) in
            expectation.fulfill()
            XCTFail()
        })
        waitForExpectations(timeout: 4) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func testModel(){
        let expectation: XCTestExpectation = self.expectation(description: "test model")

        guard let url = Bundle.main.url(forResource: "photos", withExtension: "json") else {
            XCTFail()
            return
        }
        guard let data: Data = NSData(contentsOf: url) as Data? else {
            XCTFail()
            return
        }
        XCTAssertNoThrow(try! newJSONDecoder().decode(PhotoSearch.self, from: data))
        expectation.fulfill()
        
        waitForExpectations(timeout: 4) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }

}
