//
//  GameStats.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import RealmSwift

class GameStats: Object {
    
    @Persisted var correctAnswerCount: Int
    @Persisted var percentage: Int
    
    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool
    
    @Persisted var moneyWon: Int
    
    @Persisted var fatalQuestion: String?
    @Persisted var correctAnswer: String?
    
    @Persisted var gameDate: String?
    @Persisted var gameStatus: String?
}
