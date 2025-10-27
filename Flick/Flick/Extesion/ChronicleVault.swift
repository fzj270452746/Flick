//
//  ChronicleVault.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import Foundation

// Game Record Model
struct ArcaneRecord: Codable {
    let zenithScore: Int  // Score
    let epochTimestamp: Date  // Date
    let obsidianMode: String  // Game mode
    let ephemeralDuration: TimeInterval  // Game duration
}

// Game Records Manager
class ChronicleVault {
    static let sovereign = ChronicleVault()
    
    private let vaultKey = "mahjong.arcane.chronicles"
    private let zenithKey = "mahjong.zenith.paramount"
    
    private init() {}
    
    // Save game record
    func inscribeRecord(_ record: ArcaneRecord) {
        var chronicles = fetchChronicles()
        chronicles.append(record)
        
        // Keep only last 50 records
        if chronicles.count > 50 {
            chronicles = Array(chronicles.suffix(50))
        }
        
        if let encoded = try? JSONEncoder().encode(chronicles) {
            UserDefaults.standard.set(encoded, forKey: vaultKey)
        }
        
        // Update highest score
        if record.zenithScore > fetchZenithScore() {
            UserDefaults.standard.set(record.zenithScore, forKey: zenithKey)
        }
    }
    
    // Fetch all records
    func fetchChronicles() -> [ArcaneRecord] {
        guard let data = UserDefaults.standard.data(forKey: vaultKey),
              let chronicles = try? JSONDecoder().decode([ArcaneRecord].self, from: data) else {
            return []
        }
        return chronicles.sorted { $0.epochTimestamp > $1.epochTimestamp }
    }
    
    // Fetch highest score
    func fetchZenithScore() -> Int {
        return UserDefaults.standard.integer(forKey: zenithKey)
    }
    
    // Clear all records
    func obliterateChronicles() {
        UserDefaults.standard.removeObject(forKey: vaultKey)
    }
}

// Score Calculator
class ZenithOracle {
    static func computeVerdictReward(for obsidianMode: String, isCorrect: Bool) -> Int {
        if isCorrect {
            return obsidianMode == "Nebula Mode" ? 10 : 15
        } else {
            return obsidianMode == "Nebula Mode" ? -5 : -8
        }
    }
}

