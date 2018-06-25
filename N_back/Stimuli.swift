//
//  Stimuli.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation

struct Stimuli: Hashable{
    private var identifier: Int
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Stimuli, rhs: Stimuli) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Stimuli.getUniqueIdentifier()
    }
}
