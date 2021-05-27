//
//  DetailsViewModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 26/5/21.
//

import UIKit

enum Section: Int, CaseIterable, Hashable {
    case main
}

enum ListItem: Hashable {
    case header(HeaderItem)
    case detail(DetailItem)
}

struct DetailItem: Hashable {
    private let id = UUID()
    let title: String
    let details: String?
}

struct HeaderItem: Hashable {
    private let id = UUID()
    let title: String
}

class DetailsViewModel {
    
    private(set) var isFetchingProductDetails: Bool = false
    private(set) var product: ProductModel
    private(set) var productDetails: ProductDetailsResponseModel?
    var productDetailsSnapshot: NSDiffableDataSourceSectionSnapshot<ListItem>? {
        return generateSnapshot()
    }
    
    var updateHandler: ((_ productDetails: ProductDetailsResponseModel?, _ productDetailsSnapshot: NSDiffableDataSourceSectionSnapshot<ListItem>?) -> Void)?
    
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
                    self.updateHandler?(response, self.generateSnapshot())
                case .failure(let error):
                    self.productDetails = nil
                    self.updateHandler?(nil, nil)
                    print(error)
                }
            }
        }
    }
    
    private func generateSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem>? {
        guard let details = self.productDetails else {
            return nil
        }
        
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        if let features = details.features {
            let headerItem = HeaderItem(title: "Features")
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            for feature in features {
                let detailsItem = DetailItem(title: feature.type.displayString, details: feature.additionalInfo)
                let detailsListItem = ListItem.detail(detailsItem)
                sectionSnapshot.append([detailsListItem], to: headerListItem)
            }
        }
        
        if let eligibilityCriteria = details.eligibility {
            let headerItem = HeaderItem(title: "Eligibility")
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            for eligibility in eligibilityCriteria {
                let detailsItem = DetailItem(title: eligibility.type?.displayString ?? "-", details: eligibility.additionalInfo)
                let detailsListItem = ListItem.detail(detailsItem)
                sectionSnapshot.append([detailsListItem], to: headerListItem)
            }
        }
        
        if let fees = details.fees {
            let headerItem = HeaderItem(title: "Fees")
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            for fee in fees {
                var title = fee.name
                if let cost = fee.amount {
                    title += " - $\(cost)"
                }
                
                let detailsItem = DetailItem(title: title, details: fee.additionalInfo)
                let detailsListItem = ListItem.detail(detailsItem)
                sectionSnapshot.append([detailsListItem], to: headerListItem)
            }
        }
        
        return sectionSnapshot
    }
}
