//
//  ViewController.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import UIKit
import CoreLocation

protocol WeatherViewControllerDelegate {
    func updateUIWith(response: ResultWeather)
    func updateUIWith(location: CLLocation)
}

final class WeatherViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var response: ResultWeather?

    private lazy var df: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "HH:mm E"
            if let timezone = response?.city?.timezone {
                df.timeZone = TimeZone.init(secondsFromGMT: timezone)
            }
            return df
        }()

    private var icons: [URL: UIImage] = [:]

    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
    }

    //MARK: - Private actions
    private func setupUI() {
        if let response {
            if let currentTemperature = response.list?.first?.main?.temp?.rounded() {
                currentTemperatureLabel.text = "\(currentTemperature)\u{00B0}"
            }
            if let cityName = response.city?.name, let country = response.city?.country {
                cityNameLabel.text = "\(cityName), \(country)"
            }
            collectionView.reloadData()
        }
    }

    //MARK: - Public actions
    public func setResponse(response: ResultWeather) {
        self.response = response
    }
}

//MARK: - WeatherViewControllerDelegate
extension WeatherViewController: WeatherViewControllerDelegate {
    public func updateUIWith(response: ResultWeather) {
        DispatchQueue.main.async {
            self.response = response
            self.setupUI()
        }
    }

    public func updateUIWith(location: CLLocation) {
        LocationManagerImp.shared.getLocationNameWith(location: location) { [weak self] name in
            guard let self else {
                return
            }
            self.cityNameLabel.text = name
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        response?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }


        if let item = response?.list?[indexPath.row] {
            if let temp = item.main?.temp {
                cell.degreeLabel.text = "\(Int(temp))\u{00B0}"
            }
            if let description = item.weather?.first?.description {
                cell.descriptionLabel.text = description
            }
            if let dt = item.dt {
                let time = Date.init(timeIntervalSince1970: TimeInterval(dt))
                let timeString: String = df.string(from: time)
                cell.timeLabel.text = timeString
            }
        }

        cell.iconImageView.image = nil
        if let iconName = response?.list?[indexPath.row].weather?.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/w/\(iconName).png") {

                if let image = icons[url] {
                    cell.iconImageView.image = image
                }
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.icons[url] = image
                            if let self, let index = self.collectionView.indexPath(for: cell)?.row, index == indexPath.row {
                                cell.iconImageView.image = image
                            }
                        }
                    }
                }
            }
        }

        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true

        return cell
    }
}
