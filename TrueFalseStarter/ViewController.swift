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
    
    var timeoutBlocker: dispatch_block_t?
    var timeoutDisplay: Int = 0
    var timer: NSTimer?
    
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
    
    @IBAction func checkAnswer(sender: UIButton) {
        
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
            
        } else if sender === buttonNextAction {
            
            setUIForIncorrectAnswer(messageToUser: "You need to be faster!")
            
        } else {
        
            setUIForIncorrectAnswer(messageToUser: "Sorry, wrong answer!")
            dispatch_block_cancel(timeoutBlocker!)

        }
        
        // disable answer buttons and mark the correct one
        disableAnswerButtons([buttonAnswer1, buttonAnswer2, buttonAnswer3, buttonAnswer4], answerButton: sender, correctAnswer: correctAnswer!)
        
        buttonNextAction.hidden = false
        gameQuestions.removeAtIndex(gameModel.indexOfSelectedQuestion)
        
        dispatch_block_cancel(timeoutBlocker!)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        if buttonNextAction.currentTitle == gameModel.playAgainTitle {
            selectChallenge()
        }
        
        if buttonNextAction.currentTitle == gameModel.nextQuestionTitle {
            nextQuestion()
        }
    }
   
    // Helper Methods
    func selectChallenge() {
        
        labelQuestion.text = gameModel.selectChallengeTitle
        labelResult.text = ""
        
        buttonAnswer1.hidden = true
        setButtonWithTitle(buttonAnswer2, title: gameModel.textQuestionsTitle)
        setButtonWithTitle(buttonAnswer3, title: gameModel.mathQuestionsTitle)
        buttonAnswer4.hidden = true
        
        buttonNextAction.hidden = true
    }
    
    func startGame(challenge: String) {
        
        soundModel.playGameStartSound()
        
        gameModel.questionsPerGame = questionsPerGame
        gameModel.correctQuestions = 0
        
        gameQuestions = gameModel.getGameQuestions(challenge)
        buttonNextAction.setTitle(gameModel.nextQuestionTitle, forState: UIControlState.Normal)
        
        displayQuestionWithTimeout()
    }
    
    func nextQuestion() {
        if gameQuestions.count == 0 {
            displayScore()
        } else {
            displayQuestionWithTimeout()
        }
    }
    
    func displayQuestionWithTimeout() {
        
        gameModel.indexOfSelectedQuestion = randomNumberModel.getWithUpperBound(gameQuestions.count)
        let question = gameQuestions[gameModel.indexOfSelectedQuestion]
        
        labelQuestion.text = question.text
        labelResult.text = "00:\(String(format: "%02d", gameModel.timeoutQuestionInSeconds))"
        
        if question.answers.count > 0 {
            setButtonWithTitle(buttonAnswer1, title: question.answers[0].text)
        } else {
            buttonAnswer1.hidden = true
        }
 
        if question.answers.count > 1 {
            setButtonWithTitle(buttonAnswer2, title: question.answers[1].text)
        } else {
            buttonAnswer2.hidden = true
        }
        
        if question.answers.count > 2 {
            setButtonWithTitle(buttonAnswer3, title: question.answers[2].text)
        } else {
            buttonAnswer3.hidden = true
        }
        
        if question.answers.count > 3 {
            setButtonWithTitle(buttonAnswer4, title: question.answers[3].text)
        } else {
            buttonAnswer4.hidden = true
        }
        
        buttonNextAction.hidden = true
        
        timeoutBlocker = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
            self.checkAnswer(self.buttonNextAction)
        }
        
        setTimeoutOnQuestion()
    }
    
    func displayScore() {
        // Hide the answer buttons
        buttonAnswer1.hidden = true
        buttonAnswer2.hidden = true
        buttonAnswer3.hidden = true
        buttonAnswer4.hidden = true
        
        // Display play again button
        buttonNextAction.setTitle(gameModel.playAgainTitle, forState: UIControlState.Normal)
        
        labelResult.text = String()
        labelQuestion.text = gameModel.getFinalScore(questionsPerGame)
    }

    func disableAnswerButtons(buttons: [UIButton], answerButton: UIButton, correctAnswer: Answer){
        for button in buttons {
            button.enabled = false
            button.backgroundColor = colorModel.disabledBackgroundColor
            button.setTitleColor(colorModel.disabledTitleColor, forState: UIControlState.Normal)
            
            if button === answerButton
            && button.currentTitle != correctAnswer.text {
                button.setTitleColor(colorModel.incorrectTitleColor, forState: UIControlState.Normal)
            }
            
            if button.currentTitle == correctAnswer.text {
                button.setTitleColor(colorModel.correctTitleColor, forState: UIControlState.Normal)
            }
        }
    }
    
    func setButtonWithTitle(button: UIButton, title: String) {
        button.hidden = false
        button.enabled = true
        button.backgroundColor = colorModel.enabledBackgroundColor
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(colorModel.enabledTitleColor, forState: UIControlState.Normal)
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
        timer = NSTimer.scheduledTimerWithTimeInterval(timerUpdateInSeconds, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        timeoutQuestion(seconds: gameModel.timeoutQuestionInSeconds)
    }
    
    func updateTimer() {
        if timeoutDisplay >= 0 {
            labelResult.text = "00:\(String(format: "%02d", timeoutDisplay))"
            timeoutDisplay -= 1
        }
    }
    
    func timeoutQuestion(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue(), timeoutBlocker!)
    }
}

