//
//  LogsHandler.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

enum LogEvent: String {
    case error = "Error:"
    case debug = "Debug:"
}

class LogsHandler: NSObject {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    //Print all debug information on console
    class func Debug(_ message: String,
                     funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.debug.rawValue) \(funcName) -> \(message)")
    }
    
    //Print all Error information on console
    class func Error(_ message: String,
                     funcName: String = #function) {
        
        print("\(Date().toString()) \(LogEvent.error.rawValue) \(funcName) -> \(message)")
    }
}

internal extension Date {
    func toString() -> String {
        return LogsHandler.dateFormatter.string(from: self as Date)
    }
}
