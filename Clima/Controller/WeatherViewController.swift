import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() // Responsible for getting hold of current location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Modal alert
        weatherManager.delegate = self
        searchTextField.delegate = self // Reports any changes to searchTextField to "self"(WeatherView Controller class)
        
        locationManager.delegate = self // Core Location manager
        
        locationManager.requestWhenInUseAuthorization() // prompts user for permission to use location
        locationManager.requestLocation()   // Collect location one time
  
    }
}

/*
 
 textField functions from UITextFieldDelegate class can be used as @IBAction of multiple buttons.
 For example,  func textFieldDidEndEditing(_ textField: UITextField) has textField parameter. This textField is referring to the testField in the UI that caused this function to activate. Any textField object will activate textField methods
 */


/* About extension
    extension protocol_object{
    // Define default function.
 }
 
 extension extends methods in a class
 */

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // Dismisses keyboard
        print(searchTextField.text!)
        
    }
    
    // Add this function to tell what textField should do when tapping on "Return"
    // Before adding this function, must add additional protocol : UITextFieldDelegate
    // Then, add "searchTextField.delegate = self"
    // Protocol method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // Dismisses keyboard
        print(searchTextField.text!)
        return true
    }
    
    // Validating textField before end editing. (Afte tapping return)
    // Protocol method
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    // This function will automatically trigger after any ".endEditing(true)
    // Protocol method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        //Then empty out textField
        searchTextField.text = ""
    }
}


// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        // DispatchQueue.main.async {} is used because UI change in completion handler is not possible becuase
        // tasks such as networking are often executed in the background.
        // this function happens in the background. read or updating UI must be on main thread and not background.
        // To run the code in the main thread, use DispatchQueue.main.async {}
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func getCurrrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error:: \(error.localizedDescription)")
      }

      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.requestLocation()
          }
      }

    // locationManager.requestLocation() calls this method and didFailWIthError
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let location = locations.last {
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                print(" and \(lon)")
                weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
        }
}
