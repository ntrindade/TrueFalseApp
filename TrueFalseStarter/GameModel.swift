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
    
    let selectChallengeTitle = "Select Challenge"
    let mathQuestionsTitle = "Math Random Questions"
    let textQuestionsTitle = "Text Fixed Questions"
    
    let playAgainTitle = "Play again?"
    let nextQuestionTitle = "Next Question"
    
    let timeoutQuestionInSeconds = 15
    
    var questionsPerGame = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    func getGameQuestions(challenge: String) -> [Question] {
        
        if challenge == textQuestionsTitle {
            return getFixedQuestions()
        }
        
        if challenge == mathQuestionsTitle {
            return getRandomQuestions()
        }
        
        //This will never occur
        return []
    }
    
    func getFixedQuestions() -> [Question] {
        
        var gameQuestions: [Question] = []
        var indexesAlreadyPicked: [Int] = []

        for _ in 1...questionsPerGame {
            var randomFixedQuestionIndex: Int
            
            // Randomly picks a unique index
            repeat {
                randomFixedQuestionIndex = randomNumberModel.getWithUpperBound(questionModel.fixedQuestions.count)
            } while indexesAlreadyPicked.contains(randomFixedQuestionIndex)
            indexesAlreadyPicked.append(randomFixedQuestionIndex)
            
            gameQuestions.append(questionModel.fixedQuestions[randomFixedQuestionIndex])
        }
        
        return gameQuestions
    }
    
    func getRandomQuestions() -> [Question] {
        
        var gameQuestions: [Question] = []
        
        for _ in 1...questionsPerGame {
            gameQuestions.append(questionModel.getRandomQuestion())
        }
        
        return gameQuestions
    }
    
    func getFinalScore(totalQuestions: Int) -> String {
        var score = ""
        let gradePercentage = (Double(correctQuestions) / Double(totalQuestions)) * 100.0
        
        switch gradePercentage {
            case 0..<50:
                score = "Come on!!! This is all you got?\n"
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
