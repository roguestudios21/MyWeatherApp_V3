//
//  MainWeatherView.swift
//  MyWeatherApp
//
//  Created by Atharv on 08/07/25.
//

import SwiftUI
import CoreData

struct MainWeatherView: View {
    var city: String

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: SavedCity.entity(), sortDescriptors: [])
    private var savedCities: FetchedResults<SavedCity>

    @StateObject private var networkManager = NetworkManager()
    @State private var currentDayIndex = 0
    @State private var showDetails = false
    @State private var showAlert = false
    @State private var backgroundImageName: String?

    var body: some View {
        ZStack {
            if let imageName = backgroundImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .blur(radius: 2)
            } else {
                Color.black.ignoresSafeArea()
            }

            VStack {
                Spacer(minLength: 75)

                if let forecastItem = currentForecastItem {
                    CityAndDateView(
                        cityName: networkManager.cityName.isEmpty ? savedCities.first?.name ?? city : networkManager.cityName,
                        day: formattedDay(from: forecastItem.dt_txt)
                    )

                    PresentWeatherInfoView(
                        iconName: WeatherIcon(rawValue: forecastItem.weather.first?.icon ?? "")?.symbolName ?? "questionmark",
                        temperature: Int(forecastItem.main.temp),
                        description: forecastItem.weather.first?.description.capitalized ?? "N/A"
                    )
                } else if networkManager.isLoading {
                    ProgressView("Loading weather...")
                        .foregroundColor(.white)
                }

                DetailsButton {
                    withAnimation { showDetails = true }
                }

                Spacer()

                if !networkManager.forecast.isEmpty {
                    NavigationButtonsView(
                        currentDayIndex: $currentDayIndex,
                        forecastCount: networkManager.forecast.count
                    )
                }

                Spacer()
            }
            .blur(radius: showDetails ? 20 : 0)
            .overlay(
                Group {
                    if showDetails, let forecastItem = currentForecastItem {
                        DetailWeatherView(weather: forecastItem) {
                            withAnimation { showDetails = false }
                        }
                    }
                }
            )
            .animation(.easeInOut(duration: 0.3), value: showDetails)
        }
        .onAppear {
            let savedCityName = savedCities.first?.name ?? city
            networkManager.fetchForecast(for: savedCityName)
            updateBackgroundImage()
        }
        .onChange(of: currentDayIndex) {
            updateBackgroundImage()
        }
        .onChange(of: networkManager.forecast) {
            updateBackgroundImage()
        }
        .onChange(of: networkManager.errorMessage) {
            showAlert = networkManager.errorMessage != nil
        }

        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(networkManager.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    networkManager.errorMessage = nil
                }
            )
        }
    }

    private var currentForecastItem: ForecastItem? {
        guard currentDayIndex < networkManager.forecast.count else { return nil }
        return networkManager.forecast[currentDayIndex]
    }

    private func updateBackgroundImage() {
        guard let icon = currentForecastItem?.weather.first?.icon,
              let weatherIcon = WeatherIcon(rawValue: icon) else {
            backgroundImageName = nil
            return
        }
        backgroundImageName = weatherIcon.backgroundImageName
    }

    private func formattedDay(from dt_txt: String?) -> String {
        guard let dt_txt = dt_txt else { return formattedToday() }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dt_txt) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        return formattedToday()
    }

    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}

#Preview {
    MainWeatherView(city: "Mumbai")
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}


// MARK: - Subviews

struct CityAndDateView: View {
    var cityName: String
    var day: String

    var body: some View {
        VStack(spacing: 8) {
            Text(cityName)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(day)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

struct PresentWeatherInfoView: View {
    var iconName: String
    var temperature: Int
    var description: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°C")
                .font(.system(size: 80))
                .foregroundColor(.white)
            Text(description)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

struct DetailsButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Details")
                .frame(width: 280, height: 50)
                .background(Color.gray.opacity(0.7))
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(10)
                .padding()
        }
    }
}

struct NavigationButtonsView: View {
    @Binding var currentDayIndex: Int
    var forecastCount: Int

    var body: some View {
        HStack {
            Spacer()
            NavigationButton(iconName: "chevron.backward.2") {
                if currentDayIndex > 0 {
                    currentDayIndex -= 1
                }
            }
            Spacer(minLength: 200)
            NavigationButton(iconName: "chevron.forward.2") {
                if currentDayIndex < forecastCount - 1 {
                    currentDayIndex += 1
                }
            }
            Spacer()
        }
    }
}

struct NavigationButton: View {
    var iconName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding()
                .background(
                    Capsule()
                        .fill(Color.gray.opacity(0.7))
                )
        }
    }
}
