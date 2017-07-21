//
//  TargetDate.swift
//  Days To Go
//
//  Created by Joe Riggs on 7/12/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

// This is the class that defines all of the data for our little app.

import Foundation

class TargetDate : NSObject, NSCoding {

    // This is the data that we store for each target date.
    var targetDate = Int()

    // This is the init method.  It's called when we create a new object.
    init(targetDate: Int) {
        self.targetDate = targetDate
    }

    // This is the string that is displayed if we wish to print()
    // the contents of a TargetDate object.
    override var description:String {
        return "targetDate: \(self.targetDate)"
    }

    // This method is called as part of the NSKeyedArchiver class when we
    // want to encode an object before saving to disk.
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(targetDate, forKey: "targetDate")
    }

    // This method is called as part of the NSKeyedUnarchiver class when we
    // want to read our previously encoded object from disk.
    public required init?(coder aDecoder: NSCoder) {
        let nNumObj : Int = aDecoder.decodeInteger(forKey: "targetDate")
        self.targetDate = nNumObj
    }
}
