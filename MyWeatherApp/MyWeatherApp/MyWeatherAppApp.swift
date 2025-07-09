//
//  MyWeatherAppApp.swift
//  MyWeatherApp
//
//  Created by Atharv  on 07/07/25.
//

import SwiftUI

@main
struct MyWeatherAppApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            CitySelectView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
    }
}

