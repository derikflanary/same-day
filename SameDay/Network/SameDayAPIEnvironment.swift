//
//  SameDayAPIEnvironment.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal
import Alamofire

class SameDayAPIEnvironment: ProtectedAPIEnvironment, MockAPIEnvironment {

    var baseURL: URL?
    var bearerToken: String?
    let forceRefresh: Bool
    var isRefreshing = false
    let protocolClass: AnyClass?

    var isExpired: Bool {
        return bearerToken == nil
    }

    init(environment: Environment, bearerToken: String?) {
        self.baseURL = URL(string: environment.apiURLBase)
        self.bearerToken = bearerToken
        switch environment {
        case .prod:
            self.forceRefresh = false
            protocolClass = nil
        }
    }

    func refresh(completion: ((Bool) -> Void)?) {
        bearerToken = App.sharedCore.state.accessToken
        completion?(bearerToken != nil)
    }

}


protocol SameDayAPICommand: NetworkCommand where StateType == AppState { }

extension SameDayAPICommand {

    func network(from state: AppState) -> API {
        return NetworkConfig.shared.sameDay
    }
    
}
