//
//  SoundModel.swift
//  TrueFalseStarter
//
//  Created by Nuno Trindade on 19/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import AudioToolbox

struct SoundModel {
    var soundFiles: [String: SystemSoundID] = ["GameSound": 0, "Correct": 1, "Incorrect": 2]
    
    mutating func loadGameSounds() {
        for (soundFile, var id) in soundFiles {
            let pathToSoundFile = Bundle.main.path(forResource: soundFile, ofType: "wav")
            let soundURL = URL(fileURLWithPath: pathToSoundFile!)
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &id)
            soundFiles[soundFile] = id
        }
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(soundFiles["GameSound"]!)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(soundFiles["Correct"]!)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(soundFiles["Incorrect"]!)
    }
}
