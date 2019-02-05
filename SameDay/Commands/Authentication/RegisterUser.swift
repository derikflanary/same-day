//
//  RegisterUser.swift
//  SameDay
//
//  Created by Derik Flanary on 1/22/19.
//  Copyright © 2019 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct RegisterUser: SameDayAPICommand {
 
    let firstname: String
    let lastname: String
    let email: String
    let username: String
    let password: String
    
    init(username: String, password: String, firstname: String, lastname: String, email: String) {
        self.username = username
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
    }
    
    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Register.register(firstName: firstname, lastName: lastname, email: email, username: username, password: password)
        network.sessionManager.startRequestsImmediately = true
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            guard let json = response.value else { return }
            if let _: JSONObject = try? json.value(for: Keys.error) {
                core.fire(event: AuthenticationFailed(message: "You must be a valid Agemni user to regester. Check your username and password and try again"))
            } else {
                core.fire(command: Authenticate(username: self.username, password: self.password))
            }
        }
    }

}
