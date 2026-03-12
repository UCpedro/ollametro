import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: OllametroViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    headerCard
                    levelSelectorCard
                    launchButton

                    if let error = viewModel.launchError {
                        warningCard(error)
                    }

                    if let result = viewModel.result {
                        resultCard(result)
                            .transition(.asymmetric(insertion: .scale(scale: 0.96).combined(with: .opacity), removal: .opacity))

                        RouteMapView(origin: viewModel.santiago, destination: result.place)
                            .frame(height: 235)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
                    }

                    if !viewModel.history.isEmpty {
                        historySection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGray6), Color(.secondarySystemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Ollámetro 🍲")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Mide qué tan lejos se te fue la olla")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Text("Santiago de Chile siempre es el punto de partida.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }

    private var levelSelectorCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.levelText)
                .font(.headline.weight(.semibold))

            HStack(spacing: 6) {
                ForEach(1...10, id: \.self) { level in
                    levelButton(level)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }

    private func levelButton(_ level: Int) -> some View {
        let isSelected = Int(viewModel.selectedLevel.rounded()) == level

        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.selectedLevel = Double(level)
            }
        } label: {
            Text("\(level)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(isSelected ? Color.orange : Color(.systemGray5))
                )
        }
        .buttonStyle(.plain)
    }

    private var launchButton: some View {
        Button(action: viewModel.launchOlla) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                Text("Lanzar olla")
                    .font(.headline.weight(.bold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundStyle(.white)
            .background(
                LinearGradient(colors: [Color.orange, Color.red], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .orange.opacity(0.35), radius: 10, y: 4)
        }
    }

    private func resultCard(_ result: LaunchResult) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(result.summary)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Text("A \(result.distanceKilometers.formatted()) km de Santiago — \(result.place.name), \(result.place.country)")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            Text(result.funPhrase)
                .font(.headline.weight(.bold))
                .foregroundStyle(.orange)

            Text(result.category)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)

            Button("Volver a lanzar") {
                viewModel.relaunch()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.regular)
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.07), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 9, y: 4)
    }

    private func warningCard(_ message: String) -> some View {
        Text(message)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color.red.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Últimos lanzamientos")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(viewModel.history) { past in
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(past.place.name), \(past.place.country)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        Text("Nivel \(past.level) · \(past.distanceKilometers.formatted()) km")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    Text("🍲")
                        .font(.title3)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ContentView(viewModel: OllametroViewModel())
}
