//
//  LevelDecisionViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-03.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class LevelDecisionViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AutoProgress" {
            if let ipvc = segue.destination as? InstructionPageViewController {
                ipvc.level = Level.choosedefaultlevel(level: 1)
            }
        }
    }
    
    /* This is the collection of default levels, from 1 to 10
     // Each key represents the level, and the value is a tuple in order of
     shape, position, color, sound, numback
     */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
}
