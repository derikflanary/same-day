//
//  OAuth2Token.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct OAuth2Token: Codable {

    let accessToken: String
    let expiresAt: Date
    let userId: String

    private static let oAuth2TokenKey = "oauth2token"
    private static let accessTokenKey = "authtoken"
    private static let expiresInKey = "expiresin"
    private static let expiresAtKey = "expiresAt"
    private static let requestAt = "requestat"
    private static let userIdKey = "userid"
    private static let refreshTokenKey = "refresh_token"

    init(accessToken: String, expiresAt: Date = Date.distantPast, userId: String, refreshToken: String? = nil) {
        self.accessToken = accessToken
        self.expiresAt = expiresAt
        self.userId = userId
    }

    init(object: MarshaledObject) throws {
        self.accessToken = try object.value(for: OAuth2Token.accessTokenKey)
        let expiresIn: TimeInterval = try object.value(for: OAuth2Token.expiresInKey)
        self.expiresAt = Date(timeIntervalSinceNow: expiresIn)
        self.userId = try object.value(for: OAuth2Token.userIdKey)
    }

    init?() throws {
        guard let dictionary: MarshaledObject = try Keychain().optionalForKey(OAuth2Token.oAuth2TokenKey) else { return nil }

        self.accessToken = try dictionary.value(for: OAuth2Token.accessTokenKey)
        self.expiresAt = try dictionary.value(for: OAuth2Token.expiresAtKey)
        self.userId = try dictionary.value(for: OAuth2Token.userIdKey)
    }

    func lock() throws {
        let tokenValues: NSDictionary = [
            OAuth2Token.accessTokenKey: accessToken as AnyObject,
            OAuth2Token.expiresAtKey: expiresAt as AnyObject,
            OAuth2Token.userIdKey: userId as AnyObject
        ]
        try Keychain().set(tokenValues, forKey: OAuth2Token.oAuth2TokenKey)
    }

    static func delete() {
        Keychain().deleteValue(forKey: OAuth2Token.oAuth2TokenKey)
    }

//    static func expireAccessToken(with key: String, keychain: Keychain) {
//        do {
//            guard let dictionary: MarshaledObject = try keychain.valueForKey(OAuth2Token.tokenKey(key)) else { return }
//            let accessToken: String = try dictionary.value(for: OAuth2Token.accessTokenKey)
//            let refreshToken: String? = try dictionary.value(for: OAuth2Token.refreshTokenKey)
//            let expiredOAuth2Token = OAuth2Token(accessToken: accessToken, expiresAt: Date.distantPast, refreshToken: refreshToken)
//            try expiredOAuth2Token.lock(key, keychain: keychain)
//        } catch {
//            // If we can't access the token structure, don't propagate the error
//        }
//    }

}
