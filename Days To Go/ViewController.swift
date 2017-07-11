//
//  ViewController.swift
//  Days To Go
//
//  Created by Joe Riggs on 6/17/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var targetDates : [Int] = []

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var ourTableView: UITableView!

    var timer = Timer()
    let resultFormatter = DateComponentsFormatter()
    let targetDateFormatter = DateFormatter()
    var canEdit = false

    func timerFunc() {
        ourTableView.reloadData()
    }

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
        targetDates = UserDefaults.standard.array(forKey: "targetDates") as! [Int]

        editButton.title = String("Edit")

        // Start the timer.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
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

    // Return the number of rows in the table.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetDates.count
    }

    // Build a cell for the table at the row specified by indexPath.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        // Create curTime.  It is set to the time at this instant.
        var curTime = Date()
        curTime = Date.init(timeIntervalSinceNow: 0)
        
        let endTime = Date(timeIntervalSinceReferenceDate: TimeInterval(targetDates[indexPath.row]))
        
        // Calculate the time delta, and update the display.
        if let intervalStr = resultFormatter.string(from: curTime, to: endTime) {
            cell.textLabel?.text = intervalStr
        }

        return cell
    }

    // This method states that all of the rows in the table acan be moved up and down.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // This method is called when the user moved an entry up or down in the table.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromItem = targetDates.remove(at: sourceIndexPath.row)
        targetDates.insert(fromItem, at: destinationIndexPath.row)
        UserDefaults.standard.set(targetDates, forKey: "targetDates")
    }

    // This function indicates that a row is editable.  It must return "true" if you want
    // to enable "swipe to delete" and/or "Edit" capability for the row.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return "true" if you want to enable the "Delete" or "Edit" option.
        // Return "false" if you do not.
        return canEdit
    }
    
    // This function is called when the user selects "Delete" from "Edit" mode.  It removes
    // the data for the specified row from our rowData array, and then it indicates that
    // we need to reload the table data.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            targetDates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            UserDefaults.standard.set(targetDates, forKey: "targetDates")
        }
    }

    // This method is called when we return to the main ViewController after adding
    // a new date to the list.  It will reload the list and force the table to be
    // reloaded.
    override func viewWillAppear(_ animated: Bool) {
        // Grab the saved list of endDates.  There might be a new entry in the list.
        targetDates = UserDefaults.standard.array(forKey: "targetDates") as! [Int]
        
        ourTableView.reloadData()
    }
}
