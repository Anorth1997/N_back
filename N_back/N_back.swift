//
//  N_back.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation
import UIKit

class Nback {
    var level: Level?
    var totalmatchtime = 0
    var correctmatchtime = 0
    var wrongmatchtime = 0
    private var attributeToWatch: Int {
        var numAttribute = 0
        numAttribute = level!.tracking.shape ? numAttribute + 1 : numAttribute
        numAttribute = level!.tracking.position ? numAttribute + 1: numAttribute
        numAttribute = level!.tracking.color ? numAttribute + 1 : numAttribute
        numAttribute = level!.tracking.sound ? numAttribute + 1 : numAttribute
        return numAttribute
    }
    
    var currentOne: Stimuli?
    
    var nbackones = [Stimuli]()
    
    // number of stimulus to be activated
    var round = 1
    
    
    init(level: Level){
        self.level = level
    }
    
    func checkPositionMatch(byPlayer: Bool){
        if level!.numback == nbackones.count{
            if byPlayer {
                if currentOne!.positionID! == nbackones[0].positionID! {
                    correctmatchtime += 1
                } else {
                    wrongmatchtime += 1
                }
            } else {
                if currentOne!.positionID! == nbackones[0].positionID! {
                    totalmatchtime += 1
                }
            }
        }
    }
    
    func checkSoundMatch(byPlayer: Bool) {
        if level!.numback == nbackones.count{
            if byPlayer {
                if currentOne!.soundID! == nbackones[0].soundID! {
                    correctmatchtime += 1
                } else {
                    wrongmatchtime += 1
                }
            } else {
                if currentOne!.soundID! == nbackones[0].soundID! {
                    totalmatchtime += 1
                }
            }
        }
    }
    
    func checkColorMatch(byPlayer: Bool) {
        if level!.numback == nbackones.count{
            if byPlayer {
                if currentOne!.colorID! == nbackones[0].colorID! {
                    correctmatchtime += 1
                } else {
                    wrongmatchtime += 1
                }
            } else {
                if currentOne!.colorID! == nbackones[0].colorID! {
                    totalmatchtime += 1
                }
            }
        }
    }
    
    func checkShapeMatch(byPlayer: Bool) {
        if level!.numback == nbackones.count{
            if byPlayer {
                print(currentOne!.shapeID!)
                print(nbackones[0].shapeID!)
                if currentOne!.shapeID! == nbackones[0].shapeID! {
                    correctmatchtime += 1
                } else {
                    wrongmatchtime += 1
                }
            } else {
                if currentOne!.shapeID! == nbackones[0].shapeID! {
                    totalmatchtime += 1
                }
            }
        }
    }
    
    func recordanddrop() {
        nbackones.append(currentOne!)
        if nbackones.count > level!.numback {
            nbackones.removeFirst()
        }
    }
    
    // This function involves the math to calculate the accuracy
    func calculateaccuracy() -> Double{
        let total = (round - level!.numback) * attributeToWatch
        print("\(total) trials, \(correctmatchtime) correct match, \(totalmatchtime) total match, \(wrongmatchtime) wrong match")
        return Double(total + correctmatchtime - totalmatchtime - wrongmatchtime)/Double(total)
        // the expression of dividend is a math result, it stands for the total of user correct response.
    }
}
