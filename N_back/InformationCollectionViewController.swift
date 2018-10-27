//
//  InformationCollectionViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-25.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit


var participantID = ""
var participantAge = ""

class InformationCollectionViewController: UIViewController {
    

    @IBOutlet weak var ParticipantIDTF: UITextField!
    @IBOutlet weak var PlayerAgeTF: UITextField!
    
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBAction func nextButton(_ sender: UIButton) {
        if checkValidInput() {
            participantID = ParticipantIDTF.text!
            participantAge = PlayerAgeTF.text!
            performSegue(withIdentifier: "LevelScene", sender: self)
        }
    }
    
    private func checkValidInput() -> Bool {
        if ParticipantIDTF.text!.isEmpty {
            ErrorMessage.text = "Please give a participantID"
            return false
        } else if PlayerAgeTF.text!.isEmpty {
            ErrorMessage.text = "Please tell the age of the participant"
            return false
        } else {
            return true
        }
    }
}
