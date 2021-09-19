//
//  GenericResponseModel.swift
//  TheGuardian
//
//  Created by Aparna A on 13/09/21.
//

import Foundation
import ObjectMapper

class ResponseModel : Mappable {
    
    private struct SerializationKeys {
        static let response = "response"
    }
    
    var response: GenericResponseModel?
    
    public required init?(map: Map){
    }
    
    init() {
    }
    
    public func mapping(map: Map) {
        response <- map[SerializationKeys.response]
    }
    
}

class GenericResponseModel : Mappable {
    
    private struct SerializationKeys {
        static let status = "status"
        static let results = "results"
        static let pageSize = "pageSize"
    }
    
    var status: String?
    var results : [ResultsModel] = []
    var pageSize : Int = 0
    
    public required init?(map: Map){
    }
    
    init() {
    }
    
    public func mapping(map: Map) {
        status <- map[SerializationKeys.status]
        results <- map[SerializationKeys.results]
        pageSize <- map[SerializationKeys.pageSize]
    }
    
}

