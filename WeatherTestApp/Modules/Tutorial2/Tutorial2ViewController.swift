//
//  Tutorial2ViewController.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import UIKit
import CoreLocation

final class Tutorial2ViewController: UIViewController {

    //MARK: - Properties
    private let locationManager: LocationManager = LocationManagerImp.shared
    private let weatherService: WeatherService = WeatherServiceImp()
    private var delegate: WeatherViewControllerDelegate?
    private var response: ResultWeather?
    private var needToShowLoader: Bool = true

    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.getUserLocation(complition: { [weak self] location in
            guard let self else {
                return
            }
            self.getCurrentWeatherWith(location: location)
        })
    }

    //MARK: - Private actions
    private func getCurrentWeatherWith(location: CLLocation) {
        weatherService.getWeatherWith(location: location) { [weak self] response in
            guard let self, let response else {
                return
            }

            DispatchQueue.main.async {
                self.response = response
                self.delegate?.updateUIWith(response: response)
                self.needToShowLoader = false
                if self.navigationController?.viewControllers.last is LoadingViewController {
                    self.goToWeatherVC()
                }
            }
        }
    }

    @IBAction private func OKButtonDidTap(_ sender: UIButton) {
        if needToShowLoader {
            presentLoadingVC()
        } else {
            goToWeatherVC()
        }
    }

    private func presentLoadingVC() {
        let storyboard = UIStoryboard(name: "LoadingVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func goToWeatherVC() {
        let storyboard = UIStoryboard(name: "WeatherVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {

            if let response {
                vc.setResponse(response: response)
            }
            delegate = vc
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
