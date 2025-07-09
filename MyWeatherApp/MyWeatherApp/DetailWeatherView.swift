//
//  DetailWeatherView.swift
//  MyWeatherApp
//
//  Created by Atharv on 07/07/25.
//

import SwiftUI

struct DetailWeatherView: View {
    let weather: ForecastItem
    var dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    XDismissButton()
                }
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    WeatherRow(title: "Temperature", value: "\(Int(weather.main.temp))°C")
                    Divider()
                    WeatherRow(title: "Humidity", value: "\(weather.main.humidity)%")
                    Divider()
                    WeatherRow(title: "Wind Speed", value: "\(weather.wind.speed) km/h")
                    Divider()
                    WeatherRow(title: "Wind Direction", value: "\(weather.wind.deg)°")
                    Divider()
                    WeatherRow(title: "Description", value: weather.weather.first?.description.capitalized ?? "N/A")
                }
                .padding(.horizontal)
            }
        }
        .frame(width: 375, height: 375)
        .background(Color(.white.opacity(0.5)))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct WeatherRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .font(.title2)
                .fontWeight(.medium)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    DetailWeatherView(
        weather: ForecastItem(
            dt: 1661871600,
            dt_txt: "2022-08-30 15:00:00",
            main: Main(temp: 28.0, humidity: 70),
            weather: [Weather(description: "Sunny", icon: "01d")],
            wind: Wind(speed: 5.0, deg: 180)
        ),
        dismiss: {}
    )
}



struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 45, height: 44)
                .foregroundColor(.black)
        }
    }
}
