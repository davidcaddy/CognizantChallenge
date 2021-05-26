//
//  DetailsViewController.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 26/5/21.
//

import UIKit

class DetailsViewController: UIViewController {

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

}
