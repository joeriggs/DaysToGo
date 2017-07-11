//
//  AddNewDateViewController.swift
//  Days To Go
//
//  Created by Joe Riggs on 7/9/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

import UIKit

class AddNewDateViewController: UIViewController {

    @IBOutlet weak var newDate: UIDatePicker!
    @IBAction func saveNewDate(_ sender: Any) {

        // Get the new date that the user selected.
        let newDateInt = Int(newDate.date.timeIntervalSinceReferenceDate)

        // We'll build the new list of dates here.
        var newTargetDates : [Int] = []

        // If the user already has some dates, add the new one to the end
        // of their list.  Otherwise, the new entry is the first entry in the list.
        if let oldTargetDates = UserDefaults.standard.array(forKey: "targetDates") {
            newTargetDates = oldTargetDates as! [Int]
        }
        newTargetDates.append(newDateInt)

        // Save the new list of target dates.
        UserDefaults.standard.set(newTargetDates, forKey: "targetDates")

        // Leave and go back to the main ViewController.
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
