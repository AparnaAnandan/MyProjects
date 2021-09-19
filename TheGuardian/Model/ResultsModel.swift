//
//  ResultsModel.swift
//  TheGuardian
//
//  Created by Aparna A on 14/09/21.
//

import Foundation
import ObjectMapper

class ResultsModel : Mappable {
    
    private struct SerializationKeys {
        static let webPublicationDate = "webPublicationDate"
        static let webTitle = "webTitle"
        static let webUrl = "webUrl"
        static let fields = "fields"
        static let id = "id"
    }
    
    var webPublicationDate: String = ""
    var webTitle: String = ""
    var webUrl: String = ""
    var fields: [String :String] = [:]
    var id: String = ""
    
    public required init?(map: Map){
    }
    
    init() {
    }
    
    public func mapping(map: Map) {
        webPublicationDate <- map[SerializationKeys.webPublicationDate]
        webTitle <- map[SerializationKeys.webTitle]
        webUrl <- map[SerializationKeys.webUrl]
        fields <- map[SerializationKeys.fields]
        id <- map[SerializationKeys.id]
    }
    
}
