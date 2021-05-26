//
//  DetailsViewModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 26/5/21.
//

import Foundation

class DetailsViewModel {
    
    private(set) var isFetchingProductDetails: Bool = false
    private(set) var product: ProductModel
    private(set) var productDetails: ProductDetailsResponseModel?
    
    var updateHandler: ((_ productDetails: ProductDetailsResponseModel?) -> Void)?
    
    init(product: ProductModel) {
        self.product = product
    }
    
    func retrieveProductsDetails() {
        guard !self.isFetchingProductDetails else {
            return
        }
        self.isFetchingProductDetails = true
        DataManager.shared.fetchProductDetails(productID: self.product.identifier) { [weak self] response in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.isFetchingProductDetails = false
                switch response {
                case .success(let response):
                    self.productDetails = response
                    self.updateHandler?(response)
                case .failure(let error):
                    self.productDetails = nil
                    self.updateHandler?(nil)
                }
            }
        }
    }
}
