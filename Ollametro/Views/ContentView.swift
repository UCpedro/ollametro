import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: OllametroViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    levelSelector
                    launchButton
                    if let error = viewModel.launchError {
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }

                    if let result = viewModel.result {
                        resultCard(result)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        RouteMapView(origin: viewModel.santiago, destination: result.place)
                            .frame(height: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .shadow(radius: 6)
                    }

                    if !viewModel.history.isEmpty {
                        historySection
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Ollámetro 🍲")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mide qué tan lejos se te fue la olla")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Elige un nivel y lánzala. Santiago siempre es el punto de partida.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var levelSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.levelText)
                .font(.title3.bold())
            Slider(value: $viewModel.selectedLevel, in: 1...10, step: 1)
                .tint(.orange)
            HStack {
                Text("1")
                Spacer()
                Text("10")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4)
    }

    private var launchButton: some View {
        Button(action: viewModel.launchOlla) {
            HStack {
                Spacer()
                Text("Lanzar olla")
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .orange.opacity(0.35), radius: 7, y: 3)
        }
    }

    private func resultCard(_ result: LaunchResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(result.summary)
                .font(.title3.bold())
            Label("\(result.distanceKilometers.formatted()) km desde Santiago", systemImage: "airplane")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(result.funPhrase)
                .font(.headline)
                .foregroundStyle(.orange)
            Text(result.category)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
            Button("Volver a lanzar") {
                viewModel.relaunch()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 6)
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Últimos lanzamientos")
                .font(.headline)
            ForEach(viewModel.history) { past in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(past.place.name), \(past.place.country)")
                            .font(.subheadline.bold())
                        Text("Nivel \(past.level) · \(past.distanceKilometers.formatted()) km")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("🍲")
                }
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    ContentView(viewModel: OllametroViewModel())
}
