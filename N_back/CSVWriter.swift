//
//  CSVWriter.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-30.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation

class CSVWrite {
    
    // Function that gets the default documents directory where we save files
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    
    func writeHeader() {
        let header = "Trial #, Block #, Level #, Shape(C), Position(C), Color(C), Sound(C), Shape(T), Position(T), Color(T), Sound(T), numback, duration, ISI, gridAppearance, object ID, position ID, color ID, sound ID, Object Button, Position Button, Color Button, Sound Button, Object(Answer), Position(Answer), Color(Answer), Sound(Answer), Object RT, Position RT, Color RT, Sound RT\n"
        
        
        
        if checkForExistenceOfFile() == false {
            // create the participant output data file and write the header
            print("can't find file, write the header")
            if writeHelper(str: header, append: false) == false{
                print("failed to write header")
            }
        }
    }
    
    // Function to write a single line of the csv file, takes in a list of the elements to write
    func writeLine(elements: [String]) {
        var line = ""
        for i in 0...(elements.count - 1) {
            if i == (elements.count - 1) {
                line += "\(elements[i])\n"
            } else {
                line += "\(elements[i]),"
            }
        }
        if writeHelper(str: line, append: true) == false {
            print("failed to write line ")
        }
    }
    
    
    // helper function to write in CSV file, return if successfully written
    func writeHelper(str: String, append: Bool) -> Bool{
        let name = participantID + "-" + participantAge + ".csv"
        let path = getDocumentsDirectory().appendingPathComponent(name)
        
        if let outputStream = OutputStream(url: path, append: append) {
            outputStream.open()
            let bytesWritten = outputStream.write(str)
            if bytesWritten < 0 {
                print("Write failure")
                return false
            }
            outputStream.close()
            return true
        } else {
            print("Unable to open file")
            return false
        }
    }

    
    // Check if the file already exists, if does return true, and we don't need to write header again

    func checkForExistenceOfFile() -> Bool {
        let name = participantID + "-" + participantAge + ".csv"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(name) {
            let filePath = pathComponent.path
            let fm = FileManager.default
            if fm.fileExists(atPath: filePath) {
                print("file exist")
                return true
            } else {
                print("file not exist")
                return false
            }
        } else {
            print("not available")
            return false
        }
    }
    
}

// OutputStream extension from community wiki
extension OutputStream {
    func write(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) -> Int {
        if let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) {
            return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int in
                var pointer = bytes
                var bytesRemaining = data.count
                var totalBytesWritten = 0
                
                while bytesRemaining > 0 {
                    let bytesWritten = self.write(pointer, maxLength: bytesRemaining)
                    if bytesWritten < 0 {
                        return -1
                    }
                    
                    bytesRemaining -= bytesWritten
                    pointer += bytesWritten
                    totalBytesWritten += bytesWritten
                }
                
                return totalBytesWritten
            }
        }
        
        return -1
    }
}
