//
//  ViewController.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    private let CELL_IDENTIFIER = "ProductCell"
    private let CELL_INTERITEM_SPACING: CGFloat = {
        return UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    }()
    private let CELL_LINE_SPACING: CGFloat = {
        return UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    }()
    private let SECTION_INSETS: UIEdgeInsets = {
        return UIDevice.current.userInterfaceIdiom == .pad ? .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0) : .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }()
    
    private var viewModel: ProductsViewModel!
    
    static func newInstance(viewModel: ProductsViewModel) -> ProductsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productsViewController = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController {
            productsViewController.viewModel = viewModel
            return productsViewController
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.alwaysBounceVertical = true
        
        self.refreshControl.addTarget(self, action:#selector(refreshData), for: .valueChanged)
        self.collectionView.refreshControl = self.refreshControl
        
        let collectionViewLayout = ProductsCollectionViewLayout(minimumInteritemSpacing: CELL_INTERITEM_SPACING, minimumLineSpacing: CELL_LINE_SPACING, sectionInset: SECTION_INSETS)
        collectionViewLayout.columnCountProvider = { collectionViewBounds in
            #if targetEnvironment(macCatalyst)
                let maxColumnWidth: CGFloat = 280.0
                return Int(collectionViewBounds.width / maxColumnWidth)
            #else
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    if (self.traitCollection.horizontalSizeClass == .compact) {
                        return 1
                    }
                    
                    return UIDevice.current.orientation.isPortrait ? 2 : 3
                }
                else {
                    return 1
                }
            #endif
        }
        self.collectionView.setCollectionViewLayout(collectionViewLayout, animated: false)
        
        self.viewModel.updateHandler = { [weak self] products in
            guard let self = self else {
                return
            }
            
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
        
        self.activityIndicatorView.startAnimating()
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateLayout), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Interface Update Implementation
    
    @objc func refreshData() {
        self.viewModel.retrieveProductsList()
    }
    
    // MARK: UICollectionViewDelegate Implementation

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! ProductCollectionViewCell
        
        if let product = self.viewModel.products?[indexPath.item] {
            cell.titleLabel.text = product.name
            cell.detailsLabel.text = product.description
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let productCount = self.viewModel.products?.count {
            if (indexPath.item == (productCount - 1)), self.viewModel.hasMorePages {
                self.viewModel.retrieveProductsList(page: viewModel.currentPage + 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = self.viewModel.products?[indexPath.item] {
            let detailsViewModel = DetailsViewModel(product: product)
            if let detailsViewController = DetailsViewController.newInstance(viewModel: detailsViewModel) {
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    detailsViewController.modalPresentationStyle = .formSheet
                    self.navigationController?.present(detailsViewController, animated: true, completion: nil)
                }
                else {
                    self.navigationController?.pushViewController(detailsViewController, animated: true)
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    @objc func updateLayout() {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

