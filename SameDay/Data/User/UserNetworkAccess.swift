//
//  UserNetworkAccess.swift
//  SameDay
//
//  Created by Derik Flanary on 6/6/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire


protocol UserNetworkAccess {
    func getUser(id: Int, completion: @escaping (_ objectJSON: DataResponse<Any>?) -> Void)
    func getAreas(completion: @escaping (_ objectJSON: DataResponse<Any>?) -> Void)
}


struct UserNetworkAPIAccess: UserNetworkAccess {

    typealias networkCompletion = (_ objectJSON: DataResponse<Any>?) -> Void

    // MARK: - Shared instance

    static let sharedInstance = UserNetworkAPIAccess()
    let baseURLString = "https://dishpros.quicktechapp.com"
    let headers: HTTPHeaders = [
        "Authorization": "Bearer d8923yur9238rh4398rh32p8eij38heruq3hep8wu4fhuiefbdsjvbndskjfbudfbq39eqy28eq"
    ]

    func getUser(id: Int, completion: @escaping networkCompletion) {
        Alamofire.request("\(baseURLString)/employee/\(id)", method: .get, headers: headers).responseJSON(completionHandler: completion)
    }

    func getAreas(completion: @escaping (DataResponse<Any>?) -> Void) {
        Alamofire.request("\(baseURLString)/areas", method: .get, headers: headers).responseJSON(completionHandler: completion)
    }

}
