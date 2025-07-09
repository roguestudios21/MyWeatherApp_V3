//
//  PersistenceController.swift
//  MyWeatherApp
//
//  Created by Atharv  on 09/07/25.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyWeatherApp") // name must match your .xcdatamodeld file
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
    }
}
