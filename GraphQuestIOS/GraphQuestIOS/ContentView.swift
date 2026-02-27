import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.indigo.opacity(0.9), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                if viewModel.gameCompleted {
                    finalBossView
                } else {
                    miniChallengeView
                }
            }
            .navigationTitle("Graph Quest")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var miniChallengeView: some View {
        VStack(spacing: 16) {
            headerCard
            graphArena(for: viewModel.currentChallenge)
            questionCard
            optionsList
            actionButtons
            resultPanel
        }
        .padding()
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.currentChallenge.title)
                .font(.headline)
            Text(viewModel.currentChallenge.prompt)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.challenges.count))
                .tint(.mint)

            Text("Score: \(viewModel.score)")
                .font(.caption)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func graphArena(for challenge: MiniChallenge) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Interactive Graph Arena")
                .font(.subheadline)
                .bold()

            GraphCanvas(challenge: challenge)
                .frame(height: 230)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Objective")
                .font(.subheadline)
                .bold()
            Text(viewModel.currentChallenge.objective)
                .font(.callout)
            Text("Hint: \(viewModel.currentChallenge.hint)")
                .font(.footnote)
                .foregroundStyle(.yellow)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var optionsList: some View {
        VStack(spacing: 10) {
            ForEach(Array(viewModel.currentChallenge.options.enumerated()), id: \.offset) { index, option in
                Button {
                    viewModel.selectOption(index)
                } label: {
                    HStack {
                        Text(option)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if viewModel.selectedOptionIndex == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.mint)
                        }
                    }
                    .padding()
                    .background(viewModel.selectedOptionIndex == index ? Color.mint.opacity(0.2) : Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.showResult)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("Submit") {
                viewModel.submitAnswer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.selectedOptionIndex == nil || viewModel.showResult)

            Button("Next") {
                viewModel.nextChallenge()
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.showResult)
        }
    }

    @ViewBuilder
    private var resultPanel: some View {
        if viewModel.showResult {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.wasCorrect ? "✅ Correct" : "❌ Not quite")
                    .font(.headline)
                Text(viewModel.currentChallenge.explanation)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var finalBossView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("🏁 Final Boss Unlocked")
                    .font(.title2)
                    .bold()
                Text("\(viewModel.finalChallenge.questionName) • \(viewModel.finalChallenge.difficulty)")
                    .font(.headline)
                Text(viewModel.finalChallenge.narrative)
                    .font(.callout)

                Text("Solution Path")
                    .font(.headline)

                ForEach(Array(viewModel.finalChallenge.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    Label("\(idx + 1). \(step)", systemImage: "point.3.filled.connected.trianglepath.dotted")
                        .font(.footnote)
                }

                Text(viewModel.finalChallenge.complexity)
                    .font(.subheadline)
                    .foregroundStyle(.mint)

                Button("Play Again") {
                    viewModel.resetGame()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct GraphCanvas: View {
    let challenge: MiniChallenge

    private func node(for id: Int) -> GraphNode? {
        challenge.nodes.first(where: { $0.id == id })
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(Array(challenge.edges.enumerated()), id: \.offset) { _, edge in
                    if let from = node(for: edge.from), let to = node(for: edge.to) {
                        Path { path in
                            path.move(to: from.position)
                            path.addLine(to: to.position)
                        }
                        .stroke(edge.isBridgeCandidate ? Color.red : Color.white.opacity(0.65), style: StrokeStyle(lineWidth: edge.isBridgeCandidate ? 4 : 2, dash: edge.isBridgeCandidate ? [8, 4] : []))
                    }
                }

                ForEach(challenge.nodes) { node in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 34, height: 34)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        Text(node.name)
                            .font(.caption2)
                    }
                    .position(node.position)
                }
            }
        }
        .padding(10)
    }
}

#Preview {
    ContentView(viewModel: GameViewModel())
        .preferredColorScheme(.dark)
}
