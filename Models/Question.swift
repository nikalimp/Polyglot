//
//  Question.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import RealmSwift

class Answer: Object {
    
    @Persisted var text: String
    @Persisted var correct: Bool
}

class Question: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<Answer>
}
