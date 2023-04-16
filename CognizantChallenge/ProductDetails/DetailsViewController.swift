//
//  DetailsViewController.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 26/5/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var dataSource = createDataSource()
    
    private var viewModel: DetailsViewModel!
    
    static func newInstance(viewModel: DetailsViewModel) -> DetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            detailsViewController.viewModel = viewModel
            return detailsViewController
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.viewModel.product.name
        self.detailsLabel.text = self.viewModel.product.description
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.alwaysBounceVertical = true
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        self.collectionView.delegate = self
        
        if (UIDevice.current.userInterfaceIdiom != .phone) {
            self.dismissButton.isHidden = false
        }
        
        self.viewModel.updateHandler = { [weak self] (_, productDetailsSnapShot) in
            self?.activityIndicatorView.stopAnimating()
            self?.applySnapshot(productDetailsSnapshot: productDetailsSnapShot)
        }
        self.activityIndicatorView.startAnimating()
        self.viewModel.retrieveProductsDetails()
        
        applySnapshot(productDetailsSnapshot: self.viewModel.productDetailsSnapshot)
    }
    
    private func applySnapshot(productDetailsSnapshot: NSDiffableDataSourceSectionSnapshot<ListItem>?) {
        guard let sectionSnapshot = productDetailsSnapshot else {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
            snapshot.appendSections(Section.allCases)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            return
        }
        self.dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: User Interactions
    
    @IBAction func dismiss(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Source
    
    private func createDataSource() -> DiffableDataSource {
        let headerCellReg = headerCellRegistration()
        let detailCellReg = detailCellRegistration()
        
        return DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, listItem -> UICollectionViewCell? in
            switch listItem {
            case .header(let headerItem):
                return collectionView.dequeueConfiguredReusableCell(
                    using: headerCellReg, for: indexPath, item: headerItem)
            case .detail(let item):
                return collectionView.dequeueConfiguredReusableCell(
                  using: detailCellReg, for: indexPath, item: item)
            }
        }
    }

}

// MARK: - CollectionView Cells
extension DetailsViewController {
    
    private func headerCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> {
        return .init { cell, _, headerItem in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = headerItem.title
            cell.contentConfiguration = configuration
            
            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            let disclosureAccessory = UICellAccessory.outlineDisclosure(options: options)
            cell.accessories = [disclosureAccessory]
        }
    }
    
    private func detailCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, DetailItem> {
        return .init { cell, _, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.title
            configuration.secondaryText = item.details
            cell.contentConfiguration = configuration
        }
    }
}

extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}
