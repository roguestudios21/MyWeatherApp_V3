//
//  WeatherIcon.swift
//  MyWeatherApp
//
//  Created by Atharv on 08/07/25.
//

import Foundation

enum WeatherIcon: String {
    case clearDay = "01d"
    case clearNight = "01n"
    case fewCloudsDay = "02d"
    case fewCloudsNight = "02n"
    case scatteredCloudsDay = "03d"
    case scatteredCloudsNight = "03n"
    case brokenCloudsDay = "04d"
    case brokenCloudsNight = "04n"
    case showerRainDay = "09d"
    case showerRainNight = "09n"
    case rainDay = "10d"
    case rainNight = "10n"
    case thunderstormDay = "11d"
    case thunderstormNight = "11n"
    case snowDay = "13d"
    case snowNight = "13n"
    case mistDay = "50d"
    case mistNight = "50n"

    /// System symbol name for SF Symbols
    var symbolName: String {
        switch self {
        case .clearDay: return "sun.max.fill"
        case .clearNight: return "moon.fill"
        case .fewCloudsDay: return "cloud.sun.fill"
        case .fewCloudsNight: return "cloud.moon.fill"
        case .scatteredCloudsDay, .brokenCloudsDay: return "cloud.fill"
        case .scatteredCloudsNight, .brokenCloudsNight: return "cloud.fill"
        case .showerRainDay, .rainDay: return "cloud.sun.rain.fill"
        case .showerRainNight, .rainNight: return "cloud.moon.rain.fill"
        case .thunderstormDay, .thunderstormNight: return "cloud.bolt.rain.fill"
        case .snowDay, .snowNight: return "snowflake"
        case .mistDay, .mistNight: return "cloud.fill"  // fallback to generic cloud
        }
    }

    /// Background image name (matching your available images)
    var backgroundImageName: String {
        switch self {
        case .clearDay:
            return "sun.max.fill"
        case .clearNight:
            return "moon.fill"
        case .fewCloudsDay:
            return "cloud.sun.fill"
        case .fewCloudsNight:
            return "cloud.moon.fill"
        case .scatteredCloudsDay, .brokenCloudsDay, .mistDay:
            return "cloud.fill"
        case .scatteredCloudsNight, .brokenCloudsNight, .mistNight:
            return "cloud.fill"
        case .showerRainDay, .rainDay:
            return "cloud.sun.rain.fill"
        case .showerRainNight, .rainNight:
            return "cloud.moon.rain.fill"
        case .thunderstormDay, .thunderstormNight:
            return "cloud.bolt.rain.fill"
        case .snowDay, .snowNight:
            return "snowflake"
        }
    }
}
