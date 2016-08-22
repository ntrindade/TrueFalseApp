//
//  QuestionModel.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

struct QuestionModel {
    
    let randomNumberModel: RandomNumberModel = RandomNumberModel()
    let fixedQuestions: [Question] =
        [
            Question(text: "Only female koalas can whistle",
                answers:
                [
                    Answer(text: "Yes", isCorrect: false),
                    Answer(text: "No", isCorrect: true),
                ]),
            Question(text: "Blue whales are technically whales",
                answers:
                [
                    Answer(text: "Yes", isCorrect: true),
                    Answer(text: "No", isCorrect: false),
                ]),
            Question(text: "Camels are cannibalistic",
                answers:
                [
                    Answer(text: "Yes", isCorrect: false),
                    Answer(text: "No", isCorrect: true),
                ]),
            Question(text: "All ducks are birds",
                answers:
                [
                    Answer(text: "Yes", isCorrect: true),
                    Answer(text: "No", isCorrect: false),
                ]),
            Question(text: "This was the only US President to serve more than two consecutive terms.",
                answers:
                [
                    Answer(text: "George Washington", isCorrect: false),
                    Answer(text: "Franklin D. Roosevelt", isCorrect: true),
                    Answer(text: "Woodrow Wilson", isCorrect: false),
                    Answer(text: "Andrew Jackson", isCorrect: false),
                ]),
            Question(text: "Which of the following countries has the most residents?",
                answers:
                [
                    Answer(text: "Nigeria", isCorrect: true),
                    Answer(text: "Russia", isCorrect: false),
                    Answer(text: "Iran", isCorrect: false),
                    Answer(text: "Vietnam", isCorrect: false),
                ]),
            Question(text: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                answers:
                [
                    Answer(text: "Paris", isCorrect: false),
                    Answer(text: "Washington D.C.", isCorrect: false),
                    Answer(text: "New York City", isCorrect: true),
                    Answer(text: "Boston", isCorrect: false),
                ]),
            Question(text: "Which nation produces the most oil?",
                answers:
                [
                    Answer(text: "Iran", isCorrect: false),
                    Answer(text: "Iraq", isCorrect: false),
                    Answer(text: "Brazil", isCorrect: false),
                    Answer(text: "Canada", isCorrect: true),
                ]),
            Question(text: "Which country has most recently won consecutive World Cups in Soccer?",
                answers:
                [
                    Answer(text: "Italy", isCorrect: false),
                    Answer(text: "Brazil", isCorrect: true),
                    Answer(text: "Argentina", isCorrect: false),
                    Answer(text: "Spain", isCorrect: false),
                ]),
            Question(text: "Which of the following rivers is longest?",
                answers:
                [
                    Answer(text: "Yangtze", isCorrect: false),
                    Answer(text: "Mississippi", isCorrect: true),
                    Answer(text: "Congo", isCorrect: false),
                    Answer(text: "Mekong", isCorrect: false),
                ]),
            Question(text: "Which city is the oldest?",
                answers:
                [
                    Answer(text: "Mexico City", isCorrect: true),
                    Answer(text: "Cape Town", isCorrect: false),
                    Answer(text: "San Juan", isCorrect: false),
                    Answer(text: "Sydney", isCorrect: false),
                ]),
            Question(text: "Which country was the first to allow women to vote in national elections?",
                answers:
                [
                    Answer(text: "Poland", isCorrect: true),
                    Answer(text: "United States", isCorrect: false),
                    Answer(text: "Sweden", isCorrect: false),
                    Answer(text: "Senegal", isCorrect: false),
                ]),
            Question(text: "Which of these countries won the most medals in the 2012 Summer Games?",
                answers:
                [
                    Answer(text: "France", isCorrect: false),
                    Answer(text: "Germany", isCorrect: false),
                    Answer(text: "Japan", isCorrect: false),
                    Answer(text: "Great Britian", isCorrect: true),
                ])
        ]
    
    func getRandomQuestion() -> Question {

        var question: Question = Question(text: "", answers: [])
        let minNumberOfMathOperations = 1
        let maxNumberOfMathOperations = 4
        let maxNumberOfSumAndSubstractOperators = 10000
        let maxNumberOfMultiplyAndDiviseOperators = 100
        let numberOfAnswers = randomNumberModel.getWithLowerAndUpperBound(lowerBound: 3, upperBound: 4)
        
        // this would be probably better with an enum but since it has not been presented in the course yet I'm using a switch
        switch randomNumberModel.getWithLowerAndUpperBound(lowerBound: minNumberOfMathOperations, upperBound: maxNumberOfMathOperations) {
            
        case 1: //sum
            
            let sumOperator1 = randomNumberModel.getWithUpperBound(maxNumberOfSumAndSubstractOperators)
            let sumOperator2 = randomNumberModel.getWithUpperBound(maxNumberOfSumAndSubstractOperators)
            let sumResult = sumOperator1 + sumOperator2
            
            question.text = "What is the sum value of \(sumOperator1) with \(sumOperator2)?"
            question.answers = getRandomAnswers(numberOfAnswers, correctAnswer: sumResult)
            break
            
        case 2: //subtraction
            
            let subtractOperator1 = randomNumberModel.getWithUpperBound(maxNumberOfSumAndSubstractOperators)
            let subtractOperator2 = randomNumberModel.getWithUpperBound(maxNumberOfSumAndSubstractOperators)
            let subtractionResult = subtractOperator1 - subtractOperator2 < 0
                ? -1 * (subtractOperator1 - subtractOperator2)
                : subtractOperator1 - subtractOperator2
            
            question.text = "What is the difference value between \(subtractOperator1) and \(subtractOperator2)?"
            question.answers = getRandomAnswers(numberOfAnswers, correctAnswer: subtractionResult)
            break
            
        case 3: //multiplication
            
            let multiplyOperator1 = randomNumberModel.getWithUpperBound(maxNumberOfMultiplyAndDiviseOperators)
            let multiplyOperator2 = randomNumberModel.getWithUpperBound(maxNumberOfMultiplyAndDiviseOperators)
            let multiplicationResult = multiplyOperator1 * multiplyOperator2
            
            question.text = "What is the result of \(multiplyOperator1) times \(multiplyOperator2)?"
            question.answers = getRandomAnswers(numberOfAnswers, correctAnswer: multiplicationResult)
            break
            
        case 4: //division
            
            let dividend = randomNumberModel.getWithUpperBound(maxNumberOfMultiplyAndDiviseOperators)
            
            //divisor cannot be zero so lowerBound is 1
            let divisor = randomNumberModel.getWithLowerAndUpperBound(lowerBound: 1, upperBound: maxNumberOfMultiplyAndDiviseOperators)
            let divisionResult = dividend / divisor
            
            question.text = "What is the whole number result of the division between \(dividend) and \(divisor)?"
            question.answers = getRandomAnswers(numberOfAnswers, correctAnswer: divisionResult)
            break
            
        default:
            print("It will never reach this point.")
            break
        }
        
        return question
    }
    
    func getRandomAnswers(numberOfAnswers: Int, correctAnswer: Int) -> [Answer] {
        
        var randomAnswers: [Answer] = []
        
        let positionForCorrectAnswer = randomNumberModel.getWithLowerAndUpperBound(lowerBound: 1, upperBound: numberOfAnswers)
        let positionForClosestCorrectAnswer = randomNumberModel.getWithUpperBoundAndRestrictions(upperBound: numberOfAnswers, restrictions: [positionForCorrectAnswer])
        
        let maxIntervalClosestToCorrectAnswer = 10
        let highestLimitClosestToCorrectAnswer = correctAnswer + maxIntervalClosestToCorrectAnswer
        let lowestLimitClosestToCorrectAnwser = correctAnswer - maxIntervalClosestToCorrectAnswer < 0
                                              ? 0
                                              : correctAnswer - maxIntervalClosestToCorrectAnswer

        let maxIntervalAwayFromCorrectAnswer = 100
        let highestLimitAwayFromCorrectAnswer = correctAnswer + maxIntervalAwayFromCorrectAnswer
        let lowestLimitAwayFromCorrectAnwser = correctAnswer - maxIntervalAwayFromCorrectAnswer < 0
                                             ? 0
                                             : correctAnswer - maxIntervalAwayFromCorrectAnswer
      
        for answer in 1...numberOfAnswers {
            
            if answer == positionForCorrectAnswer {
                randomAnswers.append(Answer(text: String(correctAnswer), isCorrect: true))
                continue
            }
            
            if answer == positionForClosestCorrectAnswer {
                randomAnswers.append(Answer(text: String(randomNumberModel.getWithLowerUpperBoundAndRestrictions(lowerBound: lowestLimitClosestToCorrectAnwser, upperBound: highestLimitClosestToCorrectAnswer, restrictions: [correctAnswer])), isCorrect: false))
                continue
            }
            
            randomAnswers.append(Answer(text: String(randomNumberModel.getWithLowerUpperBoundAndRestrictions(lowerBound: lowestLimitAwayFromCorrectAnwser, upperBound: highestLimitAwayFromCorrectAnswer, restrictions: [correctAnswer])), isCorrect: false))
        }
        
        return randomAnswers
    }
    
    func getCorrectAnswer(answers: [Answer]) -> Answer? {
        
        for answer in answers {
            if answer.isCorrect == true {
                return answer
            }
        }
        
        return nil
    }
}
