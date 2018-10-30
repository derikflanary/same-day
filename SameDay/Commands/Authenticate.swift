//
//  Authenticate.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire
import Marshal

struct Authenticate: Command {

    let username: String
    let password: String

    let sessionManager = Alamofire.SessionManager()

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func execute(state: AppState, core: Core<AppState>) {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        Alamofire.request("https://samedayapi.azurewebsites.net/Authorize", headers: headers).responseJSON { response in
            if let json = response.result.value as? JSONObject {
                print(json)
                core.fire(event: AuthenticationSucceeded())
            } else if let error = response.error {
                core.fire(event: AuthenticationFailed(message: "Your username or password is incorrect."))
            }
        }

    }

}
