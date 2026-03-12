import Foundation
import CoreLocation
import SwiftUI
import UIKit

@MainActor
final class OllametroViewModel: ObservableObject {
    @Published var selectedLevel: Double = 3
    @Published var result: LaunchResult?
    @Published var history: [LaunchResult] = []
    @Published var launchError: String?

    let santiago = Place(
        name: "Santiago",
        country: "Chile",
        latitude: -33.4489,
        longitude: -70.6693
    )

    private let places: [Place]

    init(places: [Place]? = nil) {
        self.places = places ?? Self.loadLocalPlaces()
    }

    var levelText: String {
        let level = Int(selectedLevel.rounded())
        return "Nivel \(level): \(levelDescription(for: level))"
    }

    func launchOlla() {
        let level = Int(selectedLevel.rounded())
        let range = distanceRange(for: level)

        let candidates = places.filter { place in
            let distance = santiago.location.distance(from: place.location) / 1_000
            return distance >= range.lowerBound && distance < range.upperBound
        }

        guard let selectedPlace = candidates.randomElement() else {
            launchError = "No encontré destino para ese nivel. Prueba otro nivel."
            return
        }

        let distanceKm = Int((santiago.location.distance(from: selectedPlace.location) / 1_000).rounded())
        let newResult = LaunchResult(
            place: selectedPlace,
            distanceKilometers: distanceKm,
            level: level,
            funPhrase: phrase(for: level),
            category: category(for: level)
        )

        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            result = newResult
            history.insert(newResult, at: 0)
            history = Array(history.prefix(5))
            launchError = nil
        }

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    func relaunch() {
        launchOlla()
    }

    func phrase(for level: Int) -> String {
        switch level {
        case 1...2:
            return "Se te movió la olla nomás"
        case 3...4:
            return "La olla salió del barrio"
        case 5...6:
            return "La olla ya cruzó fronteras"
        case 7...8:
            return "Tu olla necesita pasaporte"
        default:
            return "Tu olla está en otra dimensión"
        }
    }

    func category(for level: Int) -> String {
        switch level {
        case 1...2:
            return "Nivel de olla: local"
        case 3...4:
            return "Nivel de olla: regional"
        case 5...6:
            return "Nivel de olla: internacional"
        case 7...8:
            return "Nivel de olla: intercontinental"
        default:
            return "Nivel de olla: legendario"
        }
    }

    private func levelDescription(for level: Int) -> String {
        switch level {
        case 1:
            return "casi todo bajo control"
        case 2:
            return "se notó un poquito"
        case 3:
            return "todavía se recupera"
        case 4:
            return "ya llamó la atención"
        case 5:
            return "modo papelón activado"
        case 6:
            return "esto ya es internacional"
        case 7:
            return "necesita traductor"
        case 8:
            return "necesita visa"
        case 9:
            return "ni Google Maps te encuentra"
        default:
            return "se fue al multiverso"
        }
    }

    private func distanceRange(for level: Int) -> Range<Double> {
        switch level {
        case 1:
            return 0..<350
        case 2:
            return 350..<900
        case 3:
            return 900..<1_800
        case 4:
            return 1_800..<3_200
        case 5:
            return 3_200..<5_000
        case 6:
            return 5_000..<7_500
        case 7:
            return 7_500..<11_000
        case 8:
            return 11_000..<14_000
        case 9:
            return 14_000..<17_000
        default:
            return 17_000..<21_000
        }
    }

    private static func loadLocalPlaces() -> [Place] {
        guard
            let url = Bundle.main.url(forResource: "world_places", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([Place].self, from: data)
        else {
            return []
        }
        return decoded
    }
}
