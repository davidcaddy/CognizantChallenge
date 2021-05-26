//
//  DetailsViewController.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 26/5/21.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
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
        
        if (UIDevice.current.userInterfaceIdiom != .phone) {
            self.dismissButton.isHidden = false
        }
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

}
