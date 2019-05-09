//
//  Helpers.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import Foundation
import UIKit

class Helpers{
    
    static func getStringParameter(parameter:String) -> String
    {
       return "\"" + parameter + "\""
    }
    
    static func saveUserInDevice(user: UserModel)
    {
        let defaults = UserDefaults.standard
        do {
            let encodedObject : Data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            defaults.set(encodedObject, forKey: "user")
            defaults.synchronize()
        } catch {}
    }
    
    static func getLoggedUser()->UserModel
    {
        let defaults = UserDefaults.standard
        var loggedUser = UserModel()
        if let data = defaults.object(forKey: "user") as? Data {

            do {
                loggedUser = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserModel)!
               // let unarc = try NSKeyedUnarchiver.init(forReadingFrom: data as Data)
               // loggedUser = unarc.decodeObject(forKey: "root") as! LoginModel
            } catch {}
        }
        
        return loggedUser
    }
    
    static func getRequestStatusImageName(requestStatus: Int) -> String
    {
        switch requestStatus {
        case Constants.RequestStatus.kRequestAccepted:
            return "ic_double_check"
        case Constants.RequestStatus.kRequestPreAccepted:
            return "ic_check"
        case Constants.RequestStatus.kRequestNotReaded:
            return ""
        case Constants.RequestStatus.kRequestReaded:
            return "ic_eye"
        case Constants.RequestStatus.kRequestEnded:
            return ""
        case Constants.RequestStatus.kRequestExecuted:
            return "ic_double_check"
        case Constants.RequestStatus.kRequestPendingPayment:
            return "ic_double_check"

        default:
            return ""
        }
    }
    
    static func formatDateToShow(date: String) -> String
    {
        let dateFormatter = DateFormatter()
       // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // edited
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from:date)!
        dateFormatter.dateFormat = "EEEE d MMM yyyy"
        return dateFormatter.string(from:date)
    }
    
    static func validateTimeInRange(startHour: Int, startMinutes: Int, endHour: Int, endMinutes: Int, selectedHour: Int, selectedMinutes: Int) -> Bool
    {
        var components = DateComponents()
        components.setValue(endHour, for: .hour)
        components.setValue(endMinutes, for: .minute)
        let date: Date = Date()
        let endMaximumDate = Calendar.current.date(byAdding: components, to: date)
        
        components.setValue(selectedHour  + 1, for: .hour)
        components.setValue(selectedMinutes + 30, for: .minute)
        let selectedDate = Calendar.current.date(byAdding: components, to: date)
        
        if(endMaximumDate?.compare(selectedDate!)  == .orderedDescending)
        {
            if(selectedHour == startHour && selectedMinutes == 0 && startMinutes == 30)
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            return false
        }
    }
    
    static func validateMinimunTimeRequest(selectedHour: Int, selectedMinutes: Int) -> Bool
    {
        if((selectedHour == 1 && selectedMinutes == 0) || selectedHour == 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
}

