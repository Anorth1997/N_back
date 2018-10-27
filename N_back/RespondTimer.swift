//
//  RespondTimer.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-30.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation
import UIKit

class RespondTimer {
    private var milliseconds: Int = 0
    
    private var timer = Timer()
    private var timerOn = false
    
    @objc private func updateTimer() {
        milliseconds += 1
    }
    
    func startCountingRespondTime() {
        timerOn = true
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func collectRespondTimeInfo() -> String{
        let respondTime = String(milliseconds)
        shutdownTimer()
        return respondTime
    }
    
    func shutdownTimer() {
        if timerOn {
            timer.invalidate()
            milliseconds = 0
            timerOn = false
        }
    }
}
