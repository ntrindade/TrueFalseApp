//
//  RandomNumber.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameplayKit          

struct RandomNumberModel {
    
    func getWithUpperBound(upperBound: Int) -> Int {
        return GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound)
    }
    
    func getWithUpperBoundAndRestrictions(upperBound upperBound: Int, restrictions: [Int]) -> Int {
        var randomNumber: Int = -1
        
        repeat {
            let tempNumber: Int = GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound)
            if restrictions.contains(tempNumber) {
                continue
            }
            randomNumber = tempNumber
            
        } while randomNumber == -1
            
        return randomNumber
    }
    
    func getWithLowerAndUpperBound(lowerBound lowerBound: Int, upperBound: Int) -> Int {
        var randomNumber: Int = lowerBound-1
        
        repeat {
            let tempNumber: Int = GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound+1)
            if tempNumber < lowerBound {
                continue
            }
            randomNumber = tempNumber
            
        } while randomNumber == lowerBound-1
        
        return randomNumber
    }
}
