//
//  WeatherService.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import CoreLocation

protocol WeatherService {
    func getWeatherWith(
        location: CLLocation,
        _ completion: @escaping (ResultWeather?) -> ()
    )
}

final class WeatherServiceImp {
    private let baseUrlPath = "https://api.openweathermap.org/data/2.5/forecast"
    private let appid = "36660e8665caf2fa9f2f41634073e651"
}

extension WeatherServiceImp: WeatherService {

    public func getWeatherWith(
        location: CLLocation,
        _ completion: @escaping (ResultWeather?) -> ()
    ) {
        let url = URL(string:"\(baseUrlPath)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(appid)")
        let session = URLSession.shared
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(3)
            let dataTask = session.dataTask(with: url!) { (data, response, error) in
                if error == nil, let data = data {
                    do {
                        let weather = try JSONDecoder().decode(ResultWeather.self, from: data)
                        completion(weather)
                    } catch {
                        print(error)
                        completion(nil)
                    }

                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        }
    }
}
