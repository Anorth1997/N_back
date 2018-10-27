//
//  CustomizedLevelViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-29.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

class CustomizedLevelViewController: UIViewController {

    private var fileURL: URL?
    private var DocumentDirURL : URL?
    var allData = [CustomizedLevel]()
    var level: Level?
    

    let fileName = "CustomizedLevel"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create custom levels array (allData)
        DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        fileURL = DocumentDirURL!.appendingPathComponent(fileName).appendingPathExtension("json")

        // load the serialized file
        do {
            let jsonDecoder = JSONDecoder()
            let savedJSONData = try Data(contentsOf: fileURL!)
            allData = try jsonDecoder.decode([CustomizedLevel].self, from: savedJSONData)
        } catch {
            print(error)
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            if let ipvc = segue.destination as? InstructionPageViewController {
                ipvc.level = self.level!
            }
        }
    }
}

extension CustomizedLevelViewController: CustomizedLevelCellDelegate {
    func didTapGo(level: Level) {
        self.level = level
        performSegue(withIdentifier: "go", sender: self)
    }
}

extension CustomizedLevelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CustomizedLevel = allData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizedLevelCell") as! CustomizedLevelCell
        
        cell.setLevel(levelInfo: CustomizedLevel)
        cell.delegate = self
        
        return cell
    }
}
