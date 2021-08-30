//
//  ProductsViewModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class ProductsViewModel {
    
    private let dataProvider: DataProvider
    private(set) var products: [ProductModel]?
    private let pageSize: Int = 20
    private(set) var currentPage: Int = 1
    private(set) var hasMorePages: Bool = false
    private(set) var isFetchingProducts: Bool = false
    
    var updateHandler: ((_ products: [ProductModel]) -> Void)?
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func retrieveProductsList(page: Int = 1) {
        guard !self.isFetchingProducts else {
            return
        }
        self.isFetchingProducts = true
        self.dataProvider.fetchProducts(pageSize: self.pageSize, pageOffset: page) { [weak self] response in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.currentPage = page
                self.isFetchingProducts = false
                switch response {
                case .success(let response):
                    self.hasMorePages = response.meta.pages ?? Int.max > self.currentPage
                    if (page == 1) {
                        self.products = response.products
                    }
                    else {
                        self.products?.append(contentsOf: response.products)
                    }
                    self.updateHandler?(response.products)
                case .failure(_):
                    self.hasMorePages = true
                    self.products = []
                    self.updateHandler?([])
                }
            }
        }
    }
}
