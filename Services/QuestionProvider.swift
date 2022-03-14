//
//  QuestionProvider.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import RealmSwift

class QuestionProvider {
    
    lazy var dbUrl = Bundle.main.url(forResource: "triviaDB", withExtension: "realm")
    lazy var configuration = Realm.Configuration(fileURL: dbUrl, readOnly: true, objectTypes: [Question.self, Answer.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetchRandom(for difficulty: Int) -> Question? {
        
        let questions = realm.objects(Question.self).filter("difficulty == \(difficulty)")
        return questions.count > 0 ? questions[Int.random(in: 0...questions.count - 1)] : nil
    }
    
    func numberOfQuestions(for difficulty: Int) -> Int? {
        
        return realm.objects(Question.self).filter("difficulty == \(difficulty)").count
    }
}
