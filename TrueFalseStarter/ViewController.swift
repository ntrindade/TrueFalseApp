//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    let questionsPerGame = 10
    let questionModel = QuestionModel()
    let randomNumberModel = RandomNumberModel()
    let colorModel = ColorModel()
    
    var soundModel = SoundModel()
    var gameModel = GameModel()

    var gameQuestions: [Question] = []

    var gameWorkItem: DispatchWorkItem? = nil
    var timeoutDisplay: Int = 0
    var timer: Timer?
    
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var buttonAnswer1: UIButton!
    @IBOutlet weak var buttonAnswer2: UIButton!
    @IBOutlet weak var buttonAnswer3: UIButton!
    @IBOutlet weak var buttonAnswer4: UIButton!
    @IBOutlet weak var buttonNextAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundModel.loadGameSounds()
        selectChallenge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {

        if sender.currentTitle == gameModel.textQuestionsTitle {
            startGame(gameModel.textQuestionsTitle)
            return
        }
        
        if sender.currentTitle == gameModel.mathQuestionsTitle {
            startGame(gameModel.mathQuestionsTitle)
            return
        }
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        let currentQuestion = gameQuestions[gameModel.indexOfSelectedQuestion]
        let correctAnswer = questionModel.getCorrectAnswer(currentQuestion.answers)
        
        if sender.currentTitle == correctAnswer?.text {
            
            setUIForCorrectAnswer(messageToUser: "Correct!")
            gameModel.correctQuestions += 1
            suspendTimeout()
            
        } else if sender === buttonNextAction {
            
            setUIForIncorrectAnswer(messageToUser: "You need to be faster!")
            
        } else {
        
            setUIForIncorrectAnswer(messageToUser: "Sorry, wrong answer!")
            suspendTimeout()
        }
        
        // disable answer buttons and mark the correct one
        disableAnswerButtons([buttonAnswer1, buttonAnswer2, buttonAnswer3, buttonAnswer4], answerButton: sender, correctAnswer: correctAnswer!)
        
        buttonNextAction.isHidden = false
        gameQuestions.remove(at: gameModel.indexOfSelectedQuestion)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if buttonNextAction.currentTitle == gameModel.playAgainTitle {
            selectChallenge()
        }
        
        if buttonNextAction.currentTitle == gameModel.nextQuestionTitle {
            nextQuestion()
        }
    }
   
    // MARK: Helper Methods
    func selectChallenge() {
        
        labelQuestion.text = gameModel.selectChallengeTitle
        labelResult.text = ""
        
        buttonAnswer1.isHidden = true
        setButtonWithTitle(buttonAnswer2, title: gameModel.textQuestionsTitle)
        setButtonWithTitle(buttonAnswer3, title: gameModel.mathQuestionsTitle)
        buttonAnswer4.isHidden = true
        
        buttonNextAction.isHidden = true
    }
    
    func startGame(_ challenge: String) {
        
        soundModel.playGameStartSound()
        
        gameModel.questionsPerGame = questionsPerGame
        gameModel.correctQuestions = 0
        
        gameQuestions = gameModel.getGameQuestions(challenge)
        buttonNextAction.setTitle(gameModel.nextQuestionTitle, for: UIControlState())
        
        displayQuestion()
        setTimeoutOnQuestion()
    }
    
    func nextQuestion() {
        if gameQuestions.count == 0 {
            displayScore()
        } else {
            
            displayQuestion()
            setTimeoutOnQuestion()
        }
    }
    
    func displayQuestion() {
        gameModel.indexOfSelectedQuestion = randomNumberModel.getWithUpperBound(gameQuestions.count)
        let question = gameQuestions[gameModel.indexOfSelectedQuestion]
        
        labelQuestion.text = question.text
        labelResult.text = "00:\(String(format: "%02d", gameModel.timeoutQuestionInSeconds))"
        
        if question.answers.count > 0 {
            setButtonWithTitle(buttonAnswer1, title: question.answers[0].text)
        } else {
            buttonAnswer1.isHidden = true
        }
 
        if question.answers.count > 1 {
            setButtonWithTitle(buttonAnswer2, title: question.answers[1].text)
        } else {
            buttonAnswer2.isHidden = true
        }
        
        if question.answers.count > 2 {
            setButtonWithTitle(buttonAnswer3, title: question.answers[2].text)
        } else {
            buttonAnswer3.isHidden = true
        }
        
        if question.answers.count > 3 {
            setButtonWithTitle(buttonAnswer4, title: question.answers[3].text)
        } else {
            buttonAnswer4.isHidden = true
        }
        
        buttonNextAction.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        buttonAnswer1.isHidden = true
        buttonAnswer2.isHidden = true
        buttonAnswer3.isHidden = true
        buttonAnswer4.isHidden = true
        
        // Display play again button
        buttonNextAction.setTitle(gameModel.playAgainTitle, for: UIControlState())
        
        labelResult.text = String()
        labelQuestion.text = gameModel.getFinalScore(questionsPerGame)
    }

    func disableAnswerButtons(_ buttons: [UIButton], answerButton: UIButton, correctAnswer: Answer){
        for button in buttons {
            button.isEnabled = false
            button.backgroundColor = colorModel.disabledBackgroundColor
            button.setTitleColor(colorModel.disabledTitleColor, for: UIControlState())
            
            if button === answerButton
            && button.currentTitle != correctAnswer.text {
                button.setTitleColor(colorModel.incorrectTitleColor, for: UIControlState())
            }
            
            if button.currentTitle == correctAnswer.text {
                button.setTitleColor(colorModel.correctTitleColor, for: UIControlState())
            }
        }
    }
    
    func setButtonWithTitle(_ button: UIButton, title: String) {
        button.isHidden = false
        button.isEnabled = true
        button.backgroundColor = colorModel.enabledBackgroundColor
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(colorModel.enabledTitleColor, for: UIControlState())
    }
    
    func setUIForCorrectAnswer(messageToUser message: String) {
        labelResult.text = message
        labelResult.textColor = colorModel.correctAnswerHeaderColor
        soundModel.playCorrectSound()
    }
    
    func setUIForIncorrectAnswer(messageToUser message: String) {
        labelResult.text = message
        labelResult.textColor = colorModel.incorrectAnswerHeaderColor
        soundModel.playIncorrectSound()
    }
    
    func setTimeoutOnQuestion() {
        
        timeoutDisplay = gameModel.timeoutQuestionInSeconds
        labelResult.textColor = colorModel.enabledTitleColor
        let timerUpdateInSeconds = 1.0
        timer = Timer.scheduledTimer(timeInterval: timerUpdateInSeconds, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        timeoutQuestion(seconds: gameModel.timeoutQuestionInSeconds)
    }
    
    func updateTimer() {
        if timeoutDisplay >= 0 {
            labelResult.text = "00:\(String(format: "%02d", timeoutDisplay))"
            timeoutDisplay -= 1
        }
    }
    
    func timeoutQuestion(seconds: Int) {
        gameWorkItem = DispatchWorkItem(qos: .default, flags: .enforceQoS) {
            self.checkAnswer(self.buttonNextAction)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds), execute: gameWorkItem!)
    }
    
    func suspendTimeout() {
        gameWorkItem?.cancel()
    }
}

