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

    init(environment: Environment) {
        self.baseURL = URL(string: environment.apiURLBase)
        switch environment {
        case .prod:
            self.forceRefresh = true
            protocolClass = nil
        }
    }

    func refresh(completion: ((Bool) -> Void)?) {
        isRefreshing = true
//        FirebaseActual.access.getUserToken { [weak self] token, error in
//            if let error = error {
//                log.error("status=refresh-failure error=\(error)")
//            }
//            guard let `self` = self else { return }
//            self.bearerToken = token
//            self.isRefreshing = false
//            completion?(token != nil)
//        }
    }

}


protocol SameDayAPICommand: NetworkCommand where StateType == AppState { }

extension SameDayAPICommand {

    func network(from state: AppState) -> API {
        return NetworkConfig.shared.sameDay
    }
    
}
