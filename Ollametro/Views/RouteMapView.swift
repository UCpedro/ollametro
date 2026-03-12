import SwiftUI
import MapKit

struct RouteMapView: View {
    let origin: Place
    let destination: Place

    var body: some View {
        Map {
            Marker(origin.name, coordinate: origin.coordinate)
                .tint(.blue)
            Marker(destination.name, coordinate: destination.coordinate)
                .tint(.red)
            MapPolyline(coordinates: [origin.coordinate, destination.coordinate])
                .stroke(.orange, lineWidth: 3)
        }
        .mapStyle(.standard(elevation: .flat))
    }
}
