//
//  ViewController.swift
//  Days To Go
//
//  Created by Joe Riggs on 6/17/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var endTime = Date()
    var timer = Timer()
    let resultFormatter = DateComponentsFormatter()
    let targetDateFormatter = DateFormatter()

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    func timerFunc() {
        // Create curTime.  It is set to the time at this instant.
        var curTime = Date()
        curTime = Date.init(timeIntervalSinceNow: 0)

        // Calculate the time delta, and update the display.
        if let intervalStr = resultFormatter.string(from: curTime, to: endTime) {
            progressLabel.text = intervalStr
        }
    }

    @IBOutlet weak var datePickerValue: UIDatePicker!
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        endTime = datePickerValue.date
        descLabel.text = targetDateFormatter.string(from: endTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set targetDateFormatter to the format we use for displaying the target date.
        targetDateFormatter.dateFormat = "dd/MM/yyyy H:mm a"
        
        // Initialize our resultFormatter.  We use it for 2 different things:
        // 1. To calculate the difference between curTime and endTime.
        // 2. To format the result that we display on the screen.
        resultFormatter.allowedUnits = [.day, .hour, .minute, .second]
        resultFormatter.unitsStyle = .abbreviated

        // Initialize endTime.  It contains our target timestamp.  This will change
        // as soon as we can save/restore dates.
        endTime = datePickerValue.date
        descLabel.text = targetDateFormatter.string(from: endTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

