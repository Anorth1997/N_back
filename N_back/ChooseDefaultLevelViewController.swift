//
//  ChooseDefaultLevelViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-03.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class ChooseDefaultLevelViewController: UIViewController {

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choose level" {
            if let levelname = (sender as? UIButton)?.currentTitle?.last {
                let level = Level.choosedefaultlevel(level: Int(String(levelname))!)
                if let ipvc = segue.destination as? InstructionPageViewController {
                    print("the chosen level is \(level)")
                    ipvc.level = level
                }
            }
        }
    }
}
