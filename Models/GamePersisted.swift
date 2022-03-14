//
//  GamePersisted.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import RealmSwift

class GamePersisted: Object {

    @Persisted var recordID: String

    @Persisted var currentQuestionNo: Int

    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool

    override static func primaryKey() -> String? {
        return "recordID"
    }
}
