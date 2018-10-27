//
//  CreatNewLevelViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-29.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class CreatNewLevelViewController: UIViewController {
    
    private var DocumentDirURL : URL?
    private var fileURL: URL?
    private var changesCheckBoxes = [String: Checkbox]()
    private var trackingCheckBoxes = [String: Checkbox]()
    private var gridAppearanceCheckbox: [Checkbox] = []
    
    
    let fileName = "CustomizedLevel"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        addCheckBoxes()
        gridAppearanceCheckbox.append(drawGridAppearceCheckbox())
        
        DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        fileURL = DocumentDirURL!.appendingPathComponent(fileName).appendingPathExtension("json")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ErrorMessage: UILabel!
    
    @IBOutlet weak var NbackInput: UITextField!
    
    @IBOutlet weak var TitleInput: UITextField!
    
    @IBOutlet weak var trialsInput: UITextField!
    @IBOutlet weak var durationInput: UITextField!
    
    @IBOutlet weak var ISIInput: UITextField!
    @IBAction func saveAndAgainButton(_ sender: UIButton) {
        if CreateCustomizedLevel() {
            clearAllUserInput()
            ErrorMessage.text = "Succeed! Making another one?"
        }
    }
    
    @IBAction func SaveAndBackButton(_ sender: UIButton) {
        if CreateCustomizedLevel() {
            performSegue(withIdentifier: "back", sender: self)
        }
    }
    
    
    private func CreateCustomizedLevel() -> Bool {
        if checkForCorrectInput() {
            let numback = Int(NbackInput.text!)!
            let title = TitleInput.text!
            let trials = Int(trialsInput.text!)!
            let duration = Double(durationInput.text!)!
            let ISI = Double(ISIInput.text!)!
            
            let changesOptions = sumUpSelectedOptions(checkboxGroup: changesCheckBoxes)
            let trackingOptions = sumUpSelectedOptions(checkboxGroup: trackingCheckBoxes)
            let appear = gridAppearanceCheckbox[0].isChecked
            
            
            
            do {
                // first check if the serialized file exists, we load the file only if it already exists
                let name = "CustomizedLevel.json"
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                if let pathComponent = url.appendingPathComponent(name) {
                    let filePath = pathComponent.path
                    let fm = FileManager.default
                    if fm.fileExists(atPath: filePath) {
                        // load the serialized file
                        let jsonDecoder = JSONDecoder()
                        let savedJSONData = try Data(contentsOf: fileURL!)
                        var jsonCustomizedLevels = try jsonDecoder.decode([CustomizedLevel].self, from: savedJSONData)
                        
                        // append the new level data
                        jsonCustomizedLevels.append(CustomizedLevel(changesoptions: changesOptions, trackingoptions: trackingOptions, numback: numback, trials: trials, duration: duration, title: title, ISI: ISI, gridAppearance: appear))
                        
                        // write to the file
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.outputFormatting = .prettyPrinted
                        let jsonData: Data = try jsonEncoder.encode(jsonCustomizedLevels)
                        let jsonString = String(data:jsonData, encoding: .utf8)
                        print(jsonString!)
                        try jsonData.write(to: fileURL!)
                        return true
                    } else {
                        // directly write to the file
                        let jsonCustomizedLevels: [CustomizedLevel] = [CustomizedLevel(changesoptions: changesOptions, trackingoptions: trackingOptions, numback: numback, trials: trials, duration: duration, title: title, ISI: ISI, gridAppearance: appear)]
                        
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.outputFormatting = .prettyPrinted
                        let jsonData: Data = try jsonEncoder.encode(jsonCustomizedLevels)
                        let jsonString = String(data:jsonData, encoding: .utf8)
                        print(jsonString!)
                        try jsonData.write(to: fileURL!)
                        return true
                    }
                } else {
                    print("not available")
                    return false
                }
            } catch let error as NSError {
                print("failed to write to URL")
                print(error)
                return false
            }
        } else {
            return false
        }
    }
    
    // Helper function to collect the information of two groups of checkboxes
    private func sumUpSelectedOptions(checkboxGroup: [String: Checkbox]) -> [String] {
        var options = [String]()
        if checkboxGroup["shapeCheckbox"]!.isChecked {
            options.append("shape")
        }
        if checkboxGroup["positionCheckbox"]!.isChecked {
            options.append("position")
        }
        if checkboxGroup["colorCheckbox"]!.isChecked {
            options.append("color")
        }
        if checkboxGroup["soundCheckbox"]!.isChecked {
            options.append("sound")
        }
        return options
    }
    
    // Helper function to clear the previous saved new level input
    private func clearAllUserInput() {
        for checkbox in changesCheckBoxes {
            checkbox.value.isChecked = false
        }
        for checkbox in trackingCheckBoxes {
            checkbox.value.isChecked = false
        }
        NbackInput.text?.removeAll()
        trialsInput.text?.removeAll()
        TitleInput.text?.removeAll()
        durationInput.text?.removeAll()
        ISIInput.text?.removeAll()
    }
    
    
    // This is the helper function for user Input error checking, return true if all user Inputs are appropriate
    private func checkForCorrectInput() -> Bool{
        if noneClicked(checkboxesGroup: changesCheckBoxes) {
            ErrorMessage.text = "Please check at least one attribute for changes list Column!"
            return false
        } else if noneClicked(checkboxesGroup: trackingCheckBoxes){
            ErrorMessage.text = "Please check at least one attribute for tracking list Column!"
            return false
        } else if checkTrackingSubsetOfChanges() == false {
            ErrorMessage.text = "Tracking group has to be a subset of changes group"
            return false
        } else if NbackInput.text!.isEmpty {
            ErrorMessage.text = "Please give a number for Nback!"
            return false
        } else if TitleInput.text!.isEmpty {
            ErrorMessage.text = "Please give a title for your customized level!"
            return false
        } else if trialsInput.text!.isEmpty {
            ErrorMessage.text = "Please give a number for trials!"
            return false
        } else if durationInput.text!.isEmpty {
            ErrorMessage.text = "Please give a number for duration!"
            return false
        } else if ISIInput.text!.isEmpty {
            ErrorMessage.text = "Please give a number for ISI!"
            return false
        } else {
            return true
        }
    }
    
    
    
    // Helper function to error check if no option was chosen
    private func noneClicked(checkboxesGroup: [String: Checkbox]) -> Bool {
        var result = false
        for checkbox in checkboxesGroup {
            if checkbox.value.isChecked {
                result = true
            }
        }
        return !result
    }
    
    
    // Helper function to draw the two groups of option checkboxes
    func addCheckBoxes() {
        // changes column checkboxes
        // shape checkbox
        drawCheckBox(coordinates: CGRect(x: 400, y: 250, width: 70, height: 70), CheckBoxesGroup: "changes", checkboxName: "shapeCheckbox")
        drawCheckBox(coordinates: CGRect(x: 400, y: 360, width: 70, height: 70), CheckBoxesGroup: "changes", checkboxName: "positionCheckbox")
        drawCheckBox(coordinates: CGRect(x: 400, y: 470, width: 70, height: 70), CheckBoxesGroup: "changes", checkboxName: "colorCheckbox")
        drawCheckBox(coordinates: CGRect(x: 400, y: 580, width: 70, height: 70), CheckBoxesGroup: "changes", checkboxName: "soundCheckbox")
        
        // tracking column checkboxes
        drawCheckBox(coordinates: CGRect(x: 550, y: 250, width: 70, height: 70), CheckBoxesGroup: "tracking", checkboxName: "shapeCheckbox")
        drawCheckBox(coordinates: CGRect(x: 550, y: 360, width: 70, height: 70), CheckBoxesGroup: "tracking", checkboxName: "positionCheckbox")
        drawCheckBox(coordinates: CGRect(x: 550, y: 470, width: 70, height: 70), CheckBoxesGroup: "tracking", checkboxName: "colorCheckbox")
        drawCheckBox(coordinates: CGRect(x: 550, y: 580, width: 70, height: 70), CheckBoxesGroup: "tracking", checkboxName: "soundCheckbox")
    }
    
    
    // helper function to ensure that trackingCheckBoxes is a subset of changesCheckBoxes
    private func checkTrackingSubsetOfChanges() -> Bool {
        var result = true
        for checkbox in trackingCheckBoxes {
            if checkbox.value.isChecked {
                if changesCheckBoxes[checkbox.key]!.isChecked == false {
                    result = false
                }
            }
        }
        return result
    }
    
    // helper function to draw one single checkbox and complete setting
    private func drawCheckBox(coordinates: CGRect, CheckBoxesGroup: String, checkboxName: String) {
        let checkbox = Checkbox(frame: coordinates)
        checkbox.borderStyle = .square
        checkbox.checkmarkStyle = .tick
        checkbox.checkmarkSize = 0.7
        view.addSubview(checkbox)
        if CheckBoxesGroup == "changes" {
            changesCheckBoxes[checkboxName] = checkbox
        } else if CheckBoxesGroup == "tracking" {
            trackingCheckBoxes[checkboxName] = checkbox
        }
    }
    
    // Helper function to draw the checkbox for gridAppearance
    private func drawGridAppearceCheckbox() -> Checkbox {
        let checkbox = Checkbox(frame: CGRect(x: 880, y: 685, width: 70, height: 70))
        checkbox.borderStyle = .square
        checkbox.checkmarkStyle = .tick
        checkbox.checkmarkSize = 0.7
        view.addSubview(checkbox)
        return checkbox
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
