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
                do {
                    let authToken = try OAuth2Token(object: json)
                    try authToken.lock()

                    let userId: String = try json.value(for: Keys.userid)
                    core.fire(event: AuthenticationSucceeded())
                    core.fire(command: OnSuccessfulLogin(for: userId))
                } catch {
                    print(error)
                    core.fire(event: AuthenticationFailed(message: "Looks like something broke on our end. We will try to get it fixed as soon as possible."))

                }
            } else if response.error != nil {
                core.fire(event: AuthenticationFailed(message: "Your username or password is incorrect."))
            }
        }

    }

}


struct AuthenticateToken: Command {

    func execute(state: AppState, core: Core<AppState>) {
        if let _ = state.accessToken {
            core.fire(event: LoggedIn())
            if let userId = state.userState.currentUserId {
                core.fire(command: LoadUser(userId: userId))
                core.fire(command: LoadAppointments(for: userId))
            }
        } else {
            core.fire(event: LoggedOut())
        }
    }
    
}
