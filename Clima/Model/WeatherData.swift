import Foundation

// Need "Decodable" protocol when parsing JSON into an object
struct WeatherData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    
    let description: String
    let id: Int
}

// If there is an object value in JSON, we need Decodable struct with the properties corresponding to that object value in JSON. For example, our weather API returns JSON with main object and its properites. To gain access, we need to also create Main Decodable struct and include the same properties.
