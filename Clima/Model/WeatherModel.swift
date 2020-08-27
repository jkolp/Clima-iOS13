import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    // Computed property.
    // Must be var.
    var conditionName: String {
        return getConditionName(weatherID: conditionID)
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    func getConditionName(weatherID: Int) -> String {
           switch weatherID {
           case 200...232:
               return "cloud.bolt"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 600...622:
               return "cloud.snow"
           case 701...781:
               return "cloud.fog"
           case 800:
               return "sun.max"
           case 801...804:
               return "cloud.bolt"
           default:
               return "cloud"
           }
    }
    
}
