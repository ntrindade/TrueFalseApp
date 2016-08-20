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
                    Answer(text: "True", isCorrect: false),
                    Answer(text: "False", isCorrect: true),
                ]),
            Question(text: "Blue whales are technically whales",
                answers:
                [
                    Answer(text: "True", isCorrect: true),
                    Answer(text: "False", isCorrect: false),
                ]),
            Question(text: "Camels are cannibalistic",
                answers:
                [
                    Answer(text: "True", isCorrect: false),
                    Answer(text: "False", isCorrect: true),
                ]),
            Question(text: "All ducks are birds",
                answers:
                [
                    Answer(text: "True", isCorrect: true),
                    Answer(text: "False", isCorrect: false),
                ]),
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
        let maxNumberForIncorrectAnswer = 1000
        let maxNumberClosestToCorrectAnswer = 100
        let positionForCorrectAnswer = randomNumberModel.getWithLowerAndUpperBound(lowerBound: 1, upperBound: numberOfAnswers)
        let positionForClosestCorrectAnswer = randomNumberModel.getWithUpperBoundAndRestrictions(upperBound: numberOfAnswers, restrictions: [positionForCorrectAnswer])
        
        for answer in 1...numberOfAnswers {
            
            if answer == positionForCorrectAnswer {
                randomAnswers.append(Answer(text: String(correctAnswer), isCorrect: true))
                continue
            }
            
            if answer == positionForClosestCorrectAnswer {
                randomAnswers.append(Answer(text: String(randomNumberModel.getWithUpperBound(maxNumberClosestToCorrectAnswer) + correctAnswer), isCorrect: false))
                continue
            }
            
            randomAnswers.append(Answer(text: String(randomNumberModel.getWithUpperBound(maxNumberForIncorrectAnswer)), isCorrect: false))
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
