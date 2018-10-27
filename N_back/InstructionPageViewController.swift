//
//  InstructionPageViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-08-11.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class InstructionPageViewController: UIViewController {

    @IBOutlet weak var Instructionjpg: UIImageView!
    
    // Keep the information of the current level.
    var level: Level?
    
    override func viewDidLoad() {
        Instructionjpg.image = UIImage(named: "instruction.jpg")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            if let vc = segue.destination as? GameBoardViewController {
                vc.game = Nback(level: level!)
            }
        }
    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
