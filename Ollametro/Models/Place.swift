import Foundation
import CoreLocation

struct Place: Codable, Identifiable, Hashable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    var id: String { "\(name)-\(country)-\(latitude)-\(longitude)" }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LaunchResult: Identifiable, Hashable {
    let id = UUID()
    let place: Place
    let distanceKilometers: Int
    let level: Int
    let funPhrase: String
    let category: String

    var summary: String {
        "Tu olla cayó en \(place.name), \(place.country)"
    }
}
