//
//  N_back.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation

class Nback {
    var Stimulus = [Stimuli]()
    
    var timer = Timer()
    
    init(numberofStimulus: Int){
        for _ in 1...numberofStimulus {
            let stimuli = Stimuli()
            Stimulus.append(stimuli)
        }
    }
}
