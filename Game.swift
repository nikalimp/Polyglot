//
//  Game.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation

final class Game {
    
    static let shared = Game()
    private init() {}
    
    let version = "1.0.0"
    
    let payout = [
        1: 500,
        2: 1_000,
        3: 2_000,
        4: 3_000,
        5: 5_000,
        6: 10_000,
        7: 15_000,
        8: 25_000,
        9: 50_000,
        10: 100_000,
        11: 200_000,
        12: 400_000,
        13: 800_000,
        14: 1_500_000,
        15: 3_000_000,
    ]
    
    let letterForAnswerIndex = [
        0: "A",
        1: "B",
        2: "C",
        3: "D",
    ]
    
    let questionsTotal = 15
    let delayInterval: TimeInterval = 1.0
    
    var gameSession: GameSession?
    
    var current: Int {
        
        var current = self.gameSession?.currentQuestionNo ?? 0
        
        if self.gameSession?.gameStatus == .lost && current > 0 {
            current -= 1
        }
        
        return current
    }
    
    var percentage: Int {
        
        return current * 100 / questionsTotal
    }
    
    var currentQuestion: String {
        
        return self.gameSession?.currentQuestion?.text ?? ""
    }
    
    var correctAnswer: String {
        
        return self.gameSession?.currentQuestion?.answers[self.gameSession?.currentQuestion?.correctIndex ?? 0].text ?? ""
    }
    
    var gameStatus: String {
        
        guard let status = self.gameSession?.gameStatus else { return "---" }
        
        switch status {
        case .unInitialized: return "не инициализирована."
        case .lost: return "проиграна."
        case .won: return "выиграна."
        case .abortedByUser: return "прервана пользователем."
        case .inProgress: return "в процессе."
        default: return "не инициализирована."
        }
    }
    
    var moneyWon: Int {
        
        guard let status = self.gameSession?.gameStatus else { return 0 }
        
        switch status {
        case .lost: return self.gameSession!.earnedMoneyGuaranteed
        case .abortedByUser: return self.gameSession!.earnedMoney
        case .won: return payout[questionsTotal] ?? 3_000_000
        case .unInitialized: return 0
        default: return 0
        }
    }
}

let objectTypes = [GameStats.self, GamePersisted.self]
