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
    let questionModel: QuestionModel = QuestionModel()
    let randomNumberModel = RandomNumberModel()
    
    var soundModel = SoundModel()
    var gameModel: GameModel = GameModel()
    
    var gameQuestions: [Question] = []
    
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var buttonAnswer1: UIButton!
    @IBOutlet weak var buttonAnswer2: UIButton!
    @IBOutlet weak var buttonAnswer3: UIButton!
    @IBOutlet weak var buttonAnswer4: UIButton!
    @IBOutlet weak var buttonNextAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        let currentQuestion = gameQuestions[gameModel.indexOfSelectedQuestion]
        let correctAnswer = questionModel.getCorrectAnswer(currentQuestion.answers)
        
        if sender.currentTitle == correctAnswer?.text {
            
            gameModel.correctQuestions += 1
            labelResult.text = "Correct!"
            labelResult.textColor = gameModel.correctAnswerColor
            soundModel.playCorrectSound()
        } else {
        
            labelResult.text = "Sorry, wrong answer!"
            labelResult.textColor = gameModel.incorrectAnswerColor
            soundModel.playIncorrectSound()
        }

        gameQuestions.removeAtIndex(gameModel.indexOfSelectedQuestion)
        loadNextRoundWithDelay(seconds: 2)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        gameModel.correctQuestions = 0
        startGame()
    }
   
    // Helper Methods
    func startGame() {
        
        if buttonNextAction.currentTitle != gameModel.playAgainTitle {
            soundModel.loadGameSounds()
        }
        
        soundModel.playGameStartSound()
        gameModel.questionsPerGame = questionsPerGame
        gameQuestions = gameModel.getGameQuestions()
        
        displayQuestion()
    }
    
    func nextQuestion() {
        if gameQuestions.count == 0 {
            displayScore()
        } else {
            displayQuestion()
        }
    }
    
    func displayQuestion() {
        gameModel.indexOfSelectedQuestion = randomNumberModel.getWithUpperBound(gameQuestions.count)
        let question = gameQuestions[gameModel.indexOfSelectedQuestion]
        
        labelQuestion.text = question.text
        labelResult.text = ""
        
        if question.answers.count > 0 {
            buttonAnswer1.setTitle(question.answers[0].text, forState: UIControlState.Normal)
            buttonAnswer1.hidden = false
        } else {
            buttonAnswer1.hidden = true
        }
 
        if question.answers.count > 1 {
            buttonAnswer2.setTitle(question.answers[1].text, forState: UIControlState.Normal)
            buttonAnswer2.hidden = false
        } else {
            buttonAnswer2.hidden = true
        }
        
        if question.answers.count > 2 {
            buttonAnswer3.setTitle(question.answers[2].text, forState: UIControlState.Normal)
            buttonAnswer3.hidden = false
        } else {
            buttonAnswer3.hidden = true
        }
        
        if question.answers.count > 3 {
            buttonAnswer4.setTitle(question.answers[3].text, forState: UIControlState.Normal)
            buttonAnswer4.hidden = false
        } else {
            buttonAnswer4.hidden = true
        }
        
        buttonNextAction.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        buttonAnswer1.hidden = true
        buttonAnswer2.hidden = true
        buttonAnswer3.hidden = true
        buttonAnswer4.hidden = true
        
        // Display play again button
        buttonNextAction.hidden = false
        buttonNextAction.setTitle(gameModel.playAgainTitle, forState: UIControlState.Normal)
        
        labelQuestion.text = gameModel.getFinalScore(questionsPerGame)
        labelResult.text = ""
    }   
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)

        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextQuestion()
        }
    }
}

