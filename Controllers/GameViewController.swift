//
//  GameViewController.swift
//  Polyglot
//
//  Created by Никита Алимпиев on 05.03.2022.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: GameSession)
}

class GameViewController: UIViewController {

    var abortedGame: GamePersisted?
    weak var gameDelegate: GameViewControllerDelegate?

    @IBOutlet weak var currentQuestionNoLabel: UILabel!
    @IBOutlet weak var currentQuestionValueLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!

    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    lazy var answerButtons = [answerButton1, answerButton2, answerButton3, answerButton4]
    
    let game = Game.shared
    let gameSession = GameSession()
    let questionProvider = QuestionProvider()
    let gameSessionCaretaker = GameSessionCaretaker()
    
    let gameOverTitle = "Ошибка"
    lazy var gameOverMessage = """
        Твой ответ неверный!
        Выигрыш составил\(gameSession.earnedMoneyGuaranteed > 0 ? "в размере несгораемого остатка равен \("\n" + gameSession.earnedMoneyGuaranteed.formatted) ₽." : "равен нулю.")
        Игра окончена.
        """
    
    let winTitle = "Вы выиграли"
    let winMessage = """
        Поздравляю!
        """
    
    private func endGame(_ session: GameSession) {
        
        gameDelegate?.didEndGame(withResult: session)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func addButtonActions() {
        
        for button in answerButtons {
            button?.addTarget(self, action: #selector(answerButtonAction), for: .touchUpInside)
        }
    }
    
    private func resetGameSession() {
        
        gameSession.currentQuestionNo = 1
        gameSession.isLifelineFiftyUsed = false
        gameSession.isLifelinePhoneUsed = false
        gameSession.isLifelineAskAudienceUsed = false
        gameSession.gameStatus = .inProgress
    }
    
    private func restoreGameSession() {
        
        guard let abortedGame = abortedGame else { return }
        
        gameSession.currentQuestionNo = abortedGame.currentQuestionNo
        gameSession.isLifelineFiftyUsed = abortedGame.isLifelineFiftyUsed
        gameSession.isLifelinePhoneUsed = abortedGame.isLifelinePhoneUsed
        gameSession.isLifelineAskAudienceUsed = abortedGame.isLifelineAskAudienceUsed
        gameSession.gameStatus = .inProgress
    }
    
    private func displayQuestion() {
        
        let difficultyIndex = gameSession.currentQuestionNo
        
        guard let question = questionProvider.fetchRandom(for: difficultyIndex) else { return }
        guard let questionValue = game.payout[difficultyIndex] else { return }
        
        currentQuestionNoLabel.text = "ВОПРОС [ \(difficultyIndex) / \(game.questionsTotal) ]"
        currentQuestionValueLabel.text = "\(questionValue.formatted) ₽"
        
        currentQuestionLabel.text = question.text
        
        for (index, answer) in question.answers.enumerated() {
            
            answerButtons[index]?.setTitle(answer.text, for: .normal)
            answerButtons[index]?.backgroundColor = .unanswered
            answerButtons[index]?.alpha = 1.0
            answerButtons[index]?.isEnabled = true
            answerButtons[index]?.isHidden = false
        }
        
        gameSession.currentQuestion = question
    }
    
    private func isCorrect(_ answerIndex: Int) -> Bool {
        
        return gameSession.currentQuestion?.answers[answerIndex].correct ?? false
    }
    
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        
        let answerIndex = sender.tag

        answerButtons[answerIndex]?.backgroundColor = .answered
        
        delay { [self] in
            
            if isCorrect(answerIndex) {
                // ОТВЕТ ВЕРНЫЙ. ИДЕМ ДАЛЬШЕ.
                answerButtons[answerIndex]?.backgroundColor = .correct
                delay {
                    if gameSession.currentQuestionNo < game.questionsTotal {
                        nextQuestion()
                    } else {
                        // ИГРА ОКОНЧЕНА. ИГРОК ВЫИГРАЛ МАКСИМАЛЬНУЮ СУММУ.
                        win(answerIndex)
                    }
                }
            } else {
                // ОТВЕТ НЕВЕРНЫЙ. ЗАВЕРШАЕМ ИГРУ.
                gameOver(answerIndex)
            }
        }
    }
    
    func nextQuestion() {
        
        gameSession.currentQuestionNo += 1
        displayQuestion()
        gameSessionCaretaker.save(gameSession)
    }
    
    func gameOver(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .incorrect
        answerButtons[gameSession.currentQuestion!.correctIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .lost
        
        delay { [self] in
            displayAlert(withAlertTitle: gameOverTitle, andMessage: gameOverMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    func win(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .won
        
        delay { [self] in
            displayAlert(withAlertTitle: winTitle, andMessage: winMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        if abortedGame != nil {
            restoreGameSession()
        } else {
            resetGameSession()
        }
        
        addButtonActions()
        displayQuestion()
    }
}
