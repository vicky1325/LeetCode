import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published private(set) var challenges: [MiniChallenge] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var score: Int = 0
    @Published private(set) var selectedOptionIndex: Int?
    @Published private(set) var showResult: Bool = false
    @Published private(set) var wasCorrect: Bool = false
    @Published private(set) var gameCompleted: Bool = false

    let finalChallenge = LeetCodeFinalChallenge(
        questionName: "1192. Critical Connections in a Network",
        difficulty: "Hard",
        narrative: "Use your mini-level intuition to identify bridge edges with Tarjan's algorithm.",
        solutionSteps: [
            "Create adjacency list for all servers.",
            "Track discovery time and low-link value for each node.",
            "DFS through the graph while skipping parent edge.",
            "After exploring neighbor v from u, update low[u] = min(low[u], low[v]).",
            "If low[v] > disc[u], then edge (u, v) is a critical connection.",
            "Return all bridges as final answer."
        ],
        complexity: "Time O(V + E), Space O(V + E)"
    )

    init() {
        challenges = Self.seedChallenges()
    }

    var currentChallenge: MiniChallenge {
        challenges[currentIndex]
    }

    func selectOption(_ index: Int) {
        guard !showResult else { return }
        selectedOptionIndex = index
    }

    func submitAnswer() {
        guard let selectedOptionIndex, !showResult else { return }

        wasCorrect = selectedOptionIndex == currentChallenge.correctOptionIndex
        if wasCorrect {
            score += 10
        }
        showResult = true
    }

    func nextChallenge() {
        guard showResult else { return }
        selectedOptionIndex = nil
        showResult = false

        if currentIndex + 1 < challenges.count {
            currentIndex += 1
        } else {
            gameCompleted = true
        }
    }

    func resetGame() {
        currentIndex = 0
        score = 0
        selectedOptionIndex = nil
        showResult = false
        wasCorrect = false
        gameCompleted = false
    }

    private static func seedChallenges() -> [MiniChallenge] {
        [
            MiniChallenge(
                title: "Mini #1: Cycle Scanner",
                prompt: "Find whether this graph has a cycle before bridge hunting.",
                objective: "Identify the statement that proves a cycle exists in undirected DFS.",
                type: .detectCycle,
                nodes: [
                    GraphNode(id: 0, name: "0", position: CGPoint(x: 50, y: 50)),
                    GraphNode(id: 1, name: "1", position: CGPoint(x: 150, y: 50)),
                    GraphNode(id: 2, name: "2", position: CGPoint(x: 100, y: 140)),
                    GraphNode(id: 3, name: "3", position: CGPoint(x: 230, y: 120))
                ],
                edges: [
                    GraphEdge(from: 0, to: 1, weight: nil),
                    GraphEdge(from: 1, to: 2, weight: nil),
                    GraphEdge(from: 2, to: 0, weight: nil),
                    GraphEdge(from: 2, to: 3, weight: nil)
                ],
                options: [
                    "Any node with degree 1 guarantees a cycle.",
                    "Encountering a visited node that is not parent implies a cycle.",
                    "If edges = nodes - 1, graph must have a cycle.",
                    "Cycle detection requires topological sort only."
                ],
                correctOptionIndex: 1,
                hint: "Back-edge in undirected DFS is the key.",
                explanation: "In undirected graphs, hitting a previously visited node that is not the parent means a back-edge and therefore a cycle."
            ),
            MiniChallenge(
                title: "Mini #2: Bridge Guess",
                prompt: "Which edge disconnects the network if removed?",
                objective: "Predict a critical edge by visual reasoning.",
                type: .bridgeGuess,
                nodes: [
                    GraphNode(id: 0, name: "0", position: CGPoint(x: 40, y: 90)),
                    GraphNode(id: 1, name: "1", position: CGPoint(x: 120, y: 40)),
                    GraphNode(id: 2, name: "2", position: CGPoint(x: 200, y: 90)),
                    GraphNode(id: 3, name: "3", position: CGPoint(x: 280, y: 90)),
                    GraphNode(id: 4, name: "4", position: CGPoint(x: 120, y: 160))
                ],
                edges: [
                    GraphEdge(from: 0, to: 1, weight: nil),
                    GraphEdge(from: 1, to: 2, weight: nil),
                    GraphEdge(from: 2, to: 0, weight: nil),
                    GraphEdge(from: 2, to: 3, weight: nil, isBridgeCandidate: true),
                    GraphEdge(from: 1, to: 4, weight: nil)
                ],
                options: [
                    "(0, 1)", "(1, 2)", "(2, 3)", "(2, 0)"
                ],
                correctOptionIndex: 2,
                hint: "Look for the only edge connecting a region.",
                explanation: "Node 3 has only one connection to the graph through edge (2, 3), so removing it disconnects node 3."
            ),
            MiniChallenge(
                title: "Mini #3: DFS Timer",
                prompt: "During Tarjan DFS, what does low[v] > disc[u] indicate?",
                objective: "Understand the bridge condition mathematically.",
                type: .shortestPathStep,
                nodes: [
                    GraphNode(id: 0, name: "u", position: CGPoint(x: 90, y: 100)),
                    GraphNode(id: 1, name: "v", position: CGPoint(x: 220, y: 100)),
                    GraphNode(id: 2, name: "x", position: CGPoint(x: 290, y: 40)),
                    GraphNode(id: 3, name: "y", position: CGPoint(x: 290, y: 160))
                ],
                edges: [
                    GraphEdge(from: 0, to: 1, weight: nil, isBridgeCandidate: true),
                    GraphEdge(from: 1, to: 2, weight: nil),
                    GraphEdge(from: 1, to: 3, weight: nil)
                ],
                options: [
                    "u is an articulation point in every graph.",
                    "v can reach an ancestor of u through back-edge.",
                    "Edge (u, v) is a bridge.",
                    "DFS order is invalid."
                ],
                correctOptionIndex: 2,
                hint: "No back-edge from v subtree goes above u.",
                explanation: "If low[v] is greater than disc[u], v and its subtree cannot reach u or ancestors except through edge (u, v), so it is a bridge."
            )
        ]
    }
}
