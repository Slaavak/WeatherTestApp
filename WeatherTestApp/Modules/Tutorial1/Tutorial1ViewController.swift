//
//  Tutorial1ViewController.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import UIKit

final class Tutorial1ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var nextButton: UIButton!

    //MARK: - Properties
    private let locationManager: LocationManager = LocationManagerImp.shared

    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAuthorization(callback: { [weak self] status in
            self?.nextButton.isEnabled = status
        })
    }

    //MARK: - Private actions
    @IBAction private func nextButtonDidTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tutorial2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial2ViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}

