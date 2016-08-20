//
//  GameModel.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
import UIKit

struct GameModel {
    
    let questionModel = QuestionModel()
    let correctAnswerColor = UIColor(red:0.37, green:0.62, blue:0.63, alpha:1.0)
    let incorrectAnswerColor = UIColor(red:1.00, green:0.50, blue:0.31, alpha:1.0)
    let playAgainTitle = "Play again?"
    
    var questionsPerGame = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    func getGameQuestions() -> [Question] {
    
        if questionsPerGame <= questionModel.fixedQuestions.count {
            return Array(questionModel.fixedQuestions.prefix(questionsPerGame))
        }
        
        var gameQuestions: [Question] = questionModel.fixedQuestions
        let numberOfRandomQuestions = questionsPerGame - questionModel.fixedQuestions.count
        
        for _ in 1...numberOfRandomQuestions {
            gameQuestions.append(questionModel.getRandomQuestion())
        }
        
        return gameQuestions
    }
    
    func getFinalScore(totalQuestions: Int) -> String {
        var score = ""
        let gradePercentage = correctQuestions / totalQuestions * 100
        
        switch gradePercentage {
            case 0...49:
                score = "Come on!!! It's all you got?\n"
                break
            case 50...69:
                score = "Not good enough!!! You need to improve.\n"
                break
            case 70...89:
                score = "Nice!!! But can you make it to the top?\n"
                break
            case 90...100:
                score = "Wow!!! What a superstar you are.\n"
                break
            default:
                score = ""
        }
        
        return "\(score) \(correctQuestions) out of \(totalQuestions) correct questions!"
    }
}
