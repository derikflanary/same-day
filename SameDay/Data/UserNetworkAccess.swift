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
}


struct UserNetworkAPIAccess: UserNetworkAccess {

    typealias networkCompletion = (_ objectJSON: DataResponse<Any>?) -> Void

    // MARK: - Shared instance

    static let sharedInstance = UserNetworkAPIAccess()
    let baseURLString = "https://dishpros.quicktechapp.com"

    func getUser(id: Int, completion: @escaping networkCompletion) {

        Alamofire.request("\(baseURLString)/employee/\(id)/all", method: .get).responseJSON(completionHandler: completion)
    }

}
