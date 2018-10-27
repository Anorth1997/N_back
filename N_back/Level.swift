//
//  DefaultLevels.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-12.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation

struct Level: Equatable {
    
    var changes: (shape:Bool, position: Bool, color: Bool, sound: Bool) // things we distract the player
    var tracking: (shape:Bool, position: Bool, color: Bool, sound: Bool) // things we care
    var numback: Int
    var duration: Double // appearing time of each stimuli
    var trials: Int // number of trials
    var title: String // the title of this level
    var gridAppearance: Bool // The color of the grid, True is grey, False is white
    var ISI: Double // The time interval between stimulus

    static let defaultlevels = [
        1: Level(changes: (shape: true, position: false, color: false, sound: false), tracking: (shape: true, position: false, color: false, sound: false), Numback: 1, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "1"),
        2: Level(changes: (shape: true,  position: false, color: false, sound: false), tracking: (shape: true, position: false, color: false, sound: false), Numback: 2, Duration: 1.5, ISI: 0.5, gridAppearance: true,Trials: 10, Title: "2"),
        3: Level(changes: (shape: true,  position: true, color: false, sound: false), tracking: (shape: true,  position: true, color: false, sound: false), Numback: 1, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "3"),
        4: Level(changes: (shape: true,  position: true, color: false, sound: false), tracking: (shape: true,  position: true, color: false, sound: false), Numback: 2, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "4"),
        5: Level(changes: (shape: true,  position: true, color: true, sound: false), tracking: (shape: true,  position: true, color: true, sound: false), Numback: 1, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "5"),
        6: Level(changes: (shape: true,  position: true, color: true, sound: false), tracking: (shape: true,  position: true, color: true, sound: false), Numback: 2, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "6"),
        7: Level(changes: (shape: true,  position: true, color: true, sound: false), tracking: (shape: true,  position: true, color: true, sound: false), Numback: 3, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "7"),
        8: Level(changes: (shape: true,  position: true, color: true, sound: true), tracking: (shape: true,  position: true, color: true, sound: true), Numback: 1, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "8"),
        9: Level(changes: (shape: true,  position: true, color: true, sound: true), tracking: (shape: true,  position: true, color: true, sound: true), Numback: 2, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "9"),
        0: Level(changes: (shape: true,  position: true, color: true, sound: true), tracking: (shape: true,  position: true, color: true, sound: true), Numback: 3, Duration: 1.5, ISI: 0.5, gridAppearance: true, Trials: 10, Title: "10")
    ]
    
    static func choosedefaultlevel(level: Int) -> Level {
        return defaultlevels[level]!
    }
    
    static func ==(lhs: Level, rhs: Level) -> Bool{
        return lhs.changes == rhs.changes && lhs.tracking == rhs.tracking && lhs.numback == rhs.numback && lhs.duration == rhs.duration && lhs.trials == rhs.trials && lhs.ISI == rhs.ISI && lhs.gridAppearance == rhs.gridAppearance
    }
    
    init(changes:(shape:Bool, position: Bool, color: Bool, sound: Bool), tracking: (shape:Bool, position: Bool, color: Bool, sound: Bool), Numback:Int, Duration: Double, ISI: Double, gridAppearance: Bool, Trials: Int, Title: String) {
        self.changes = changes
        self.tracking = tracking
        numback = Numback
        duration = Duration
        trials = Trials
        title = Title
        self.ISI = ISI
        self.gridAppearance = gridAppearance
    }
}

extension Dictionary where Value : Equatable {
    
    func allKeysForValue(val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
    
    func firstKeyForValue(val: Value) -> Key {
        return self.allKeysForValue(val: val)[0]
    }
}
