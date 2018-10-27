//
//  AnotherGameViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-13.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class AnotherGameViewController: UIViewController {

    var level: Level?
    var defaultlevel = true // Indicate whether this is a default level or customized level

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play again" {
            print("the next level is \(level!)")
                if let ipvc = segue.destination as? InstructionPageViewController {
                    ipvc.level = self.level
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaultlevel == false {
            playButton.titleLabel?.text = "repeat the level"
        }
    }
}

