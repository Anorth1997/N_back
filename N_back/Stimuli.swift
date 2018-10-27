//
//  Stimuli.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation
import UIKit

struct Stimuli: Equatable{
    var shapeID: Int?
    var positionID: Int?
    var colorID: Int?
    var soundID: Int?
    
    init(ShapeID: Int?, PositionID: Int?, ColorID: Int?, SoundID: Int?) {
        self.shapeID = ShapeID
        self.positionID = PositionID
        self.colorID = ColorID
        self.soundID = SoundID
    }
    
    static func ==(lhs: Stimuli, rhs: Stimuli) -> Bool {
        if lhs.shapeID != rhs.shapeID, lhs.positionID != rhs.positionID, lhs.colorID != rhs.colorID, lhs.soundID != rhs.soundID {
            return false
        } else {
            return true
        }
    }
}
