import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var weather: CurrentWeather?            // Current weather
    @Published var forecast: [ForecastItem] = []
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = ""
    private var cancellable: AnyCancellable?

    func fetchWeather(for city: String) {
        isLoading = true
        errorMessage = nil

        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: CurrentWeather.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherData in
                self.weather = weatherData
            })
    }

    func fetchForecast(for city: String) {
        isLoading = true
        errorMessage = nil

        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(encodedCity)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ForecastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { forecastResponse in
                // pick 1 item per day
                var daily: [ForecastItem] = []
                let grouped = Dictionary(grouping: forecastResponse.list) { item in
                    String(item.dt_txt.prefix(10)) // "yyyy-MM-dd"
                }
                for (_, items) in grouped.sorted(by: { $0.key < $1.key }) {
                    if let first = items.first {
                        daily.append(first)
                    }
                }
                self.forecast = daily
                self.cityName = forecastResponse.city.name

            })
    }

    deinit {
        cancellable?.cancel()
    }
}
