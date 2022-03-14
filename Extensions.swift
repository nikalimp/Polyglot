//
//  Extensions.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import Foundation
import UIKit
import RealmSwift

// MARK: - Форматирование целого числа с разбивкой по разрядам в соотв. с русской локалью.

extension Int {
    
    var formatted: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "RU")
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue)"
    }
    
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        
        if range.contains(x) {
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return r == x ? range.upperBound : r
        } else {
            return Int.random(in: range)
        }
    }
}

// MARK: - Correct answer index.

extension Question {
    
    var correctIndex: Int {
        
        return self.answers.firstIndex(where:  { $0.correct }) ?? 0
    }
}

// MARK: - GameSession extensions.

extension GameSession {
    
    var earnedMoney: Int {
        
        let game = Game.shared
        return game.payout[self.currentQuestionNo - 1] ?? 0
    }
    
    var earnedMoneyGuaranteed: Int {
        
        let game = Game.shared
        
        switch self.currentQuestionNo {
        case 0...5: return 0
        case 6...10: return game.payout[5] ?? 0
        case 11...15: return game.payout[10] ?? 0
        default: return 0
        }
    }
}

// MARK: - Colors.

extension UIColor {
    
    static var unanswered: UIColor { return .systemIndigo }
    static var answered: UIColor { return .systemOrange }
    static var correct: UIColor { return .systemGreen }
    static var incorrect: UIColor { return .systemPink }
}

// MARK: - Alert extensions.

extension UIViewController {
    
    func displayAlert(withAlertTitle alertTitle: String, andMessage message: String, _ completion: ((UIAlertAction)->Void)? = nil) {
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Окей", style: .default, handler: completion)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayYesNoAlert(withAlertTitle alertTitle: String, andMessage message: String, _ completion: ((UIAlertAction)->Void)? = nil) {
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default, handler: completion)
        let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Current time stamp.

extension Date {
    
    static var currentTimeStamp: Int64{
        
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

// MARK: - Delay function.

func delay(closure: @escaping ()->()) {
    
    let game = Game.shared
    let when = DispatchTime.now() + game.delayInterval
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// MARK: - GameStats extensions.

extension GameStats {
    
    var text: String {
        
        var text = """
        Результат 🏆 игры ⚽
        Дата: \(self.gameDate ?? "-")
        Статус: \(self.gameStatus ?? "неизвестен.")
        
        Заработано: \(self.moneyWon.formatted) ₽.
        Правильные ответы: \(self.correctAnswerCount) из 15, \(self.percentage)%.
        """
        
        if self.fatalQuestion != nil {
            
            text += """
                
                
                Роковой 🔥 вопрос: \(self.fatalQuestion!)
                Правильный ответ на него: \(self.correctAnswer!)
                """
        }
        
        return text
    }
}
