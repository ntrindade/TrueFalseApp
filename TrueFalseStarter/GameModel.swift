//
//  GameModel.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
struct GameModel {
    
    let questionModel = QuestionModel()
    let randomNumberModel = RandomNumberModel()
    
    let playAgainTitle = "Play again?"
    let nextQuestionTitle = "Next Question"
    
    let timeoutQuestionInSeconds = 15
    
    var questionsPerGame = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    func getGameQuestions() -> [Question] {
        
        // Divides the total number of questions evenly by 2 so it has similar number of fixed and random questions
        let fixedQuestions = questionsPerGame / 2
        let randomQuestions = questionsPerGame - fixedQuestions
        var gameQuestions: [Question] = []
        
        // get fixed questions from array
        var indexesAlreadyPicked: [Int] = []
        for _ in 1...fixedQuestions {
            var randomFixedQuestionIndex: Int
            
            // Randomly picks a unique index
            repeat {
                randomFixedQuestionIndex = randomNumberModel.getWithUpperBound(questionModel.fixedQuestions.count)
            } while indexesAlreadyPicked.contains(randomFixedQuestionIndex)
            indexesAlreadyPicked.append(randomFixedQuestionIndex)
            
            gameQuestions.append(questionModel.fixedQuestions[randomFixedQuestionIndex])
        }
        
        //get random questions and append to gameQuestions result array
        for _ in 1...randomQuestions {
            gameQuestions.append(questionModel.getRandomQuestion())
        }
        
        return gameQuestions
    }
    
    func getFinalScore(totalQuestions: Int) -> String {
        var score = ""
        let gradePercentage = (Double(correctQuestions) / Double(totalQuestions)) * 100.0
        
        switch gradePercentage {
            case 0..<50:
                score = "Come on!!! It's all you got?\n"
                break
            case 50..<70:
                score = "Not good enough!!! You need to improve.\n"
                break
            case 70..<90:
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
