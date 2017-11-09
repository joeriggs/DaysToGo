//
//  ViewController.swift
//  Days To Go
//
//  Created by Joe Riggs on 6/17/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var targetDates : [TargetDate] = []

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var ourTableView: UITableView!
    
    var timer = Timer()
    let resultFormatter = DateComponentsFormatter()
    let targetDateFormatter = DateFormatter()
    var canEdit = false

    // MARK: Encode and Decode the targetDates Array.
    
    // This is the name of the file where targetDates array is stored.
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        let dst = (url!.appendingPathComponent("Data").path)
        print("The file path is \(dst)")
        return dst
    }
    
    // Read and decode the targetDates array that is stored in self.filePath.
    // Store it in our targetDates array.
    func loadTargetDates() -> Bool {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) {
            targetDates = ourData as! [TargetDate]
            return true
        } else {
            return false
        }
    }

    // Decode and save the targetDates array to self.filePath.
    func saveTargetDates() {
        if NSKeyedArchiver.archiveRootObject(targetDates, toFile: filePath) {
            print("SUCCESS: DATA HAS BEEN SAVED.")
        } else {
            print("FAILURE: DATA HAS NOT BEEN SAVED.")
        }
    }

    // MARK: Time function.

    // This is our one-second timer function.  All it does is force the TableView to be
    // reloaded.  Each TableView cell will be recalculated as the table is reloaded.
    @objc func timerFunc() {
        ourTableView.reloadData()
    }

    // MARK: Boiler plate stuff.

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Initialize our resultFormatter.  We use it for 2 different things:
        // 1. To calculate the difference between curTime and endTime.
        // 2. To format the result that we display on the screen.
        resultFormatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        resultFormatter.unitsStyle = .abbreviated
        resultFormatter.zeroFormattingBehavior = .dropLeading

        // Set targetDateFormatter to the format we use for displaying the target date.
        targetDateFormatter.dateFormat = "MM/dd/yyyy h:mm a"

        // Grab the saved list of endDates.
        if loadTargetDates() {
            print("Successfully loaded the old settings.")
        } else {
            print("Unable to load old settings.")
        }

        // Start the timer.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }

    // MARK: Load/reload the TableView.

    // Return the number of rows in the table.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetDates.count
    }
    
    // Build a cell for the table at the row specified by indexPath.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! MyTableViewCell
        
        // Create curTime.  It is set to the time at this instant.
        var curTime = Date()
        curTime = Date.init(timeIntervalSinceNow: 0)
        
        let endTime = Date(timeIntervalSinceReferenceDate: TimeInterval(targetDates[indexPath.row].targetDate))
        
        // Calculate the time delta, and update the display.
        if let intervalStr = resultFormatter.string(from: curTime, to: endTime) {
            cell.targetDate?.text = endTime.description
            cell.daysToGo?.text = intervalStr
        }
        
        return cell
    }

    // MARK: Unwind after running AddNewDateViewController.

    // This is the unwind function.  If the user added a new target date, we'll
    // grab it from the AddNewDateViewController class and append it to the
    // targetDates array.
    @IBAction func saveNewTargetDate(for segue: UIStoryboardSegue) {
        let addCtrl = segue.source as! AddNewDateViewController
        let targetDate : Int = Int(addCtrl.newDate.date.timeIntervalSinceReferenceDate)
        let targetDateObject = TargetDate(targetDate: targetDate)
        targetDates.append(targetDateObject)
        saveTargetDates()

        ourTableView.reloadData()
    }

    // MARK: Edit mode methods.

    // This method states that all of the rows in the table acan be moved up and down.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // This function indicates that a row is editable.  It must return "true" if you want
    // to enable "swipe to delete" and/or "Edit" capability for the row.  We only allow
    // the user to edit a row if they're in Edit mode.  This is because the rows get reset
    // everytime the one second timer expires.  So it's impossible for them to swipe and
    // delete an entry.  They have to enter Edit mode first.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return "true" if you want to enable the "Delete" or "Edit" option.
        // Return "false" if you do not.
        return canEdit
    }

    // This method runs when the user taps the Edit/Done button.
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = ourTableView.isEditing
        if isEditing {
            sender.title = String("Edit")
            canEdit = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        } else {
            sender.title = String("Done")
            canEdit = true
            timer.invalidate()
        }

        ourTableView.isEditing = !isEditing
    }

    // This method is called after the user moved an entry up or down in the table.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromItem = targetDates.remove(at: sourceIndexPath.row)
        targetDates.insert(fromItem, at: destinationIndexPath.row)
        saveTargetDates()
    }

    // This function is called when the user selects "Delete" from "Edit" mode.  It removes
    // the data for the specified row from our rowData array, and then it indicates that
    // we need to reload the table data.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            targetDates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            saveTargetDates()
        }
    }

}
