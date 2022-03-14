//
//  GameSession.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import RealmSwift

class GameSession: Object {
    
    @Persisted var currentQuestionNo: Int
    @Persisted var currentQuestion: Question?
    
    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool
    
    @objc dynamic var gameStatus: GameStatus = .unInitialized
}

@objc enum GameStatus: Int, RealmEnum {

    case unInitialized = 0
    case inProgress = 1
    case abortedByUser = 2
    case lost = 3
    case won = 4
}
