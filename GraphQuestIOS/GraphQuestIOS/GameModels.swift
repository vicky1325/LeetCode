import Foundation
import SwiftUI

struct GraphNode: Identifiable, Hashable {
    let id: Int
    let name: String
    let position: CGPoint
}

struct GraphEdge: Hashable {
    let from: Int
    let to: Int
    let weight: Int?
    var isBridgeCandidate: Bool = false
}

enum MiniChallengeType {
    case detectCycle
    case bridgeGuess
    case shortestPathStep
    case finalBoss
}

struct MiniChallenge: Identifiable {
    let id = UUID()
    let title: String
    let prompt: String
    let objective: String
    let type: MiniChallengeType
    let nodes: [GraphNode]
    let edges: [GraphEdge]
    let options: [String]
    let correctOptionIndex: Int
    let hint: String
    let explanation: String
}

struct LeetCodeFinalChallenge {
    let questionName: String
    let difficulty: String
    let narrative: String
    let solutionSteps: [String]
    let complexity: String
}
