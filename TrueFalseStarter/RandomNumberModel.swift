//
//  RandomNumber.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameplayKit          

struct RandomNumberModel {
    
    func getWithUpperBound(_ upperBound: Int) -> Int {
        return GKRandomSource.sharedRandom().nextInt(upperBound: upperBound)
    }
    
    func getWithUpperBoundAndRestrictions(upperBound: Int, restrictions: [Int]) -> Int {
        
        let lowerBoundLimit = -1
        var randomNumber: Int = -1
        
        repeat {
            let tempNumber: Int = GKRandomSource.sharedRandom().nextInt(upperBound: upperBound)
            if restrictions.contains(tempNumber) {
                continue
            }
            randomNumber = tempNumber
            
        } while randomNumber == lowerBoundLimit
            
        return randomNumber
    }
    
    func getWithLowerAndUpperBound(lowerBound: Int, upperBound: Int) -> Int {
        
        let lowerBoundLimit = lowerBound-1
        let upperBoundLimit = upperBound+1
        
        var randomNumber = lowerBoundLimit
        
        repeat {
            let tempNumber: Int = GKRandomSource.sharedRandom().nextInt(upperBound: upperBoundLimit)
            if tempNumber < lowerBound {
                continue
            }
            randomNumber = tempNumber
            
        } while randomNumber == lowerBoundLimit
        
        return randomNumber
    }
    
    func getWithLowerUpperBoundAndRestrictions(lowerBound: Int, upperBound: Int, restrictions: [Int]) -> Int {
        
        let lowerBoundLimit = lowerBound-1
        let upperBoundLimit = upperBound+1
        
        var randomNumber = lowerBoundLimit
        
        repeat {
            let tempNumber: Int = GKRandomSource.sharedRandom().nextInt(upperBound: upperBoundLimit)
            if tempNumber < lowerBound || restrictions.contains(tempNumber) {
                continue
            }
            randomNumber = tempNumber
            
        } while randomNumber == lowerBoundLimit
        
        return randomNumber
    }
}
