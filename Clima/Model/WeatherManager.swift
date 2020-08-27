import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    // use https instead of http for security issue
    let weatherURL =
   "https://api.openweathermap.org/data/2.5/weather?appid=433342c273da69e45afe531566b3a1c5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // Networking
    func performRequest(with urlString: String){
        //1. Create URL using URL Object
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession : Object that performs all network
            let session = URLSession(configuration: .default)
            
            //3. Create task for session (Using trailing closure, kind of like
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // if no error
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    // must add self. when calling a function inside closure
                    if let weather = self.parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            // add .self to make object type :WeatherData.self
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // returns decodable object : WeatherData object
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    

    

}
