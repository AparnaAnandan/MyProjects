//
//  ApiManager.swift
//  TheGuardian
//
//  Created by Aparna A on 14/09/21.
//

import Foundation
import Alamofire

struct MethodType {
    static let GET = 1
    static let PUT = 2
    static let POST = 3
}

class ApiManager {
    
    static var APIKEY = "73b46fa2-10ae-4588-a179-4766c7ba4d9d"
    static var url = "https://content.guardianapis.com/search?q=india&api-key=\(APIKEY)&show-fields=body%2Cthumbnail"

    init() { }
    
    static func sendRequestJsonResponse(url: URL, methodType : Int, body: [String:Any]?, completionHander:@escaping ((_ response: GenericResponseModel?, _ error:NSError?) -> ())) {
                
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().validate(contentType: ["application/json"]).responseJSON { (responseData) in
            
            switch responseData.result {
            
            case .success(let response):
                // Log Success response
                let genResponse = ResponseModel(JSON: response as! [String : Any])
                completionHander(genResponse?.response,nil)
                break
                
            case .failure(let error):
                completionHander(nil,error as NSError)
                break
                
            }
        }
    }
}
