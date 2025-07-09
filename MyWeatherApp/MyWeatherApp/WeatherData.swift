import Foundation

// Current weather data model
struct CurrentWeather: Decodable, Equatable {
    let name: String                // City name
    let dt: Int                     // Timestamp
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

// Forecast response model
struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: City
}

struct City: Decodable {
    let name: String
}


// Forecast item model
struct ForecastItem: Decodable, Equatable {
    let dt: Int
    let dt_txt: String              // Always present in forecast
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

// Shared nested structs
struct Main: Decodable, Equatable {
    let temp: Double
    let humidity: Int
}

struct Weather: Decodable, Equatable {
    let description: String
    let icon: String
}

struct Wind: Decodable, Equatable {
    let speed: Double
    let deg: Int
}
