//
//  CognizantChallengeTests.swift
//  CognizantChallengeTests
//
//  Created by Dave Caddy on 24/5/21.
//

import XCTest
@testable import CognizantChallenge

class CognizantChallengeTests: XCTestCase {

    private let dataProvider = MockDataProvider()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testProductsFetch() {
        let expectation = XCTestExpectation(description: "Fetch completion handler")
        self.dataProvider.fetchProducts(pageSize: 20, pageOffset: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.products.count, 20, "Products count does not match expected value")
            case .failure(_):
                XCTFail("Products list not fetched properly")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDetailsFetch() {
        let productID = "33557e367d324529b38813adfc655b55"
        let expectation = XCTestExpectation(description: "Fetch completion handler")
        self.dataProvider.fetchProductDetails(productID: productID) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.product.identifier, productID, "Product identifier does not match expected value")
            case .failure(_):
                XCTFail("Products list not fetched properly")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testProductsViewModelLoadPage1() {
        let viewModel = ProductsViewModel(dataProvider: self.dataProvider)
        let expectation = XCTestExpectation(description: "Fetch completion handler")
        viewModel.updateHandler = { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            case .success(let products):
                XCTAssertEqual(products.count, 20, "Products count does not match expected value")
                XCTAssertEqual(products.first?.identifier, "ad22b1f0967349e8a5d586afe7f0d845", "First product identifier of page 1 does not match expected value")
            }
            XCTAssertEqual(viewModel.currentPage, 1, "Current page does not match expected value")
            XCTAssertEqual(viewModel.hasMorePages, true, "Has more pages flag does not match expected value")
            expectation.fulfill()
        }
        viewModel.retrieveProductsList()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testProductsViewModelLoadPage2() {
        let viewModel = ProductsViewModel(dataProvider: self.dataProvider)
        let expectation = XCTestExpectation(description: "Fetch completion handler")
        viewModel.updateHandler = { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            case .success(let products):
                XCTAssertEqual(products.count, 20, "Products count does not match expected value")
                XCTAssertEqual(products.first?.identifier, "99563efaa4324acea46c213d7d96dd8c", "First product identifier of page 2 does not match expected value")
            }
            XCTAssertEqual(viewModel.currentPage, 2, "Current page does not match expected value")
            XCTAssertEqual(viewModel.hasMorePages, true, "Has more pages flag does not match expected value")
            expectation.fulfill()
        }
        viewModel.retrieveProductsList(page: 2)
        wait(for: [expectation], timeout: 1.0)
    }

}
