//
//  UIimage+Extension.swift
//  TheGuardian
//
//  Created by Aparna A on 18/09/21.
//

import Foundation
import UIKit
import Alamofire

class UtilityHelper {
    
    static func convertStringToDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Current time zone
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm"
        return dateFormatter.string(from: date!)
    }
    
    static func removeHTMPTags(paragraph:String?) -> String {
        if let body = paragraph {
            return (body.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil))
        }
        return ""
    }
    
    static func openBrowser(url:String?) {
        if let urlString = url, let openUrl = URL(string: urlString) {
            UIApplication.shared.open(openUrl)
        }
    }
}
