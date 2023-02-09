//
//  LoadingViewController.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import UIKit

class LoadingViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!

    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activitiIndicator.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activitiIndicator.stopAnimating()
    }
}
