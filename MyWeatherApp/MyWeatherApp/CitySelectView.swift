import SwiftUI
import CoreData

struct CitySelectView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let cities = [
        "Mumbai", "New York", "London", "Paris", "Rome",
        "Tokyo", "Berlin", "Sydney", "Moscow", "Toronto",
        "Chicago", "Los Angeles", "Dubai", "Singapore", "Seoul",
        "Bangkok", "Barcelona", "San Francisco", "Istanbul", "Cairo"
    ]

    @FetchRequest(entity: SavedCity.entity(), sortDescriptors: [])
    private var savedCities: FetchedResults<SavedCity>

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Select City")) {
                    ForEach(cities, id: \.self) { city in
                        NavigationLink {
                            MainWeatherView(city: city)
                                .onAppear { saveCity(city) }
                        } label: {
                            HStack {
                                Text(city)
                                if savedCities.first?.name == city {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cities")
        }
    }

    private func saveCity(_ name: String) {
        if let existing = savedCities.first {
            existing.name = name
        } else {
            let newCity = SavedCity(context: viewContext)
            newCity.name = name
        }
        try? viewContext.save()
    }
}

#Preview {
    CitySelectView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
