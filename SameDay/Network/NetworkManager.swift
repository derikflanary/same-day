//
//  NetworkManager.swift
//  align
//
//  Created by Tim on 1/12/18.
//  Copyright © 2018 OC Tanner. All rights reserved.
//

import Alamofire
import Foundation
import Marshal


protocol APIEnvironment {
    var baseURL: URL? { get }
}


protocol ProtectedAPIEnvironment: APIEnvironment {
    var bearerToken: String? { get }
    var forceRefresh: Bool { get }
    var isExpired: Bool { get }
    var isRefreshing: Bool { get }
    func refresh(completion: ((Bool) -> Void)?)
}


protocol MockAPIEnvironment: APIEnvironment {
    var protocolClass: AnyClass? { get }
}


class API {

    let sessionManager: Alamofire.SessionManager
    private var delegate = PausingSessionDelegate()

    var environment: APIEnvironment? {
        didSet {
            configureSessionManager()
        }
    }


    // MARK: - Initialization

    init(environment: APIEnvironment?) {
        let configuration = URLSessionConfiguration.default
        if let mock = environment as? MockAPIEnvironment, let protocolClass = mock.protocolClass {
            configuration.protocolClasses = [protocolClass]
        }
        self.sessionManager = SessionManager(configuration: configuration, delegate: delegate)
        self.sessionManager.startRequestsImmediately = false
        self.environment = environment
        configureSessionManager()
    }
    
    func refreshComplete() {
        if let protected = environment as? ProtectedAPIEnvironment {
            delegate.paused = protected.isExpired
        }
    }

    private func configureSessionManager() {
        if let protected = environment as? ProtectedAPIEnvironment {
            delegate.paused = protected.isExpired
            sessionManager.adapter = ProtectedAPIEnvironmentAdapter(environment: protected)
        } else {
            sessionManager.adapter = APIEnvironmentAdapter(environment: environment)
        }
        sessionManager.retrier = APIEnvironmentRetrier(environment: environment)
    }
    
    
    // MARK: - Helper functions
    
    /// This will call the refresh method of the environment before the request if
    /// the environment requires a refresh before the request. Used to retrieve a
    /// single object.
    ///
    /// - Parameters:
    ///   - urlRequest: Network request to be made
    ///   - responseAs: Type of response that will be fired into state
    ///   - core: The core object to use in firing events
    ///   - completion: A callback for when the request has completed
    func request<T: Unmarshaling, U>(_ urlRequest: URLRequestConvertible, responseAs: T.Type, with core: Core<U>, completion: (() -> Void)? = nil) {
        if let request = urlRequest.urlRequest {
            core.fire(event: Requested(request: request))
        }
        guard let protected = environment as? ProtectedAPIEnvironment, protected.forceRefresh else {
            sessionManager.request(urlRequest).responseAs(T.self, completionHandler: process(with: core, completion: completion))
            return
        }

        protected.refresh { [weak self] success in
            guard let `self` = self else { completion?(); return }
            self.refreshComplete()
            self.sessionManager.request(urlRequest).responseAs(T.self, completionHandler: self.process(with: core, completion: completion))
        }
    }
    
    private func process<T: Unmarshaling, U>(with core: Core<U>, completion: (() -> Void)?) -> (DataResponse<T>) -> Void {
        return { response in
            core.fire(event: Responded(url: response.request?.url, status: response.response?.statusCode))
            do {
                let object = try response.result.unwrap()
                core.fire(event: Loaded(object: object))
            } catch {
                core.fire(event: Errored(error: error))
            }
            completion?()
        }
    }
    
    /// This will call the refresh method of the environment before the request if
    /// the environment requires a refresh before the request. Used for a **list** of
    /// objects, instead of a single object.
    ///
    /// - Parameters:
    ///   - urlRequest: Network request to be made
    ///   - responseAs: Type of response that will be fired into state
    ///   - refreshObjects: Flag to determine when to fire a `Loaded<[T]>` event,
    ///     or a `Refreshed<[T]>` event the response
    ///   - core: The core object to use in firing events
    ///   - completion: A callback for when the request has completed
    func request<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: Array<T>.Type, refreshObjects: Bool = false, with core: Core<U>, completion: (() -> Void)? = nil) {
        guard let protected = environment as? ProtectedAPIEnvironment, protected.forceRefresh else {
            process(urlRequest, responseAs: Array<T>.self, refreshObjects: refreshObjects, with: core, completion: completion)
            return
        }
        
        protected.refresh { [weak self] success in
            guard let `self` = self else { completion?(); return }
            self.refreshComplete()
            self.process(urlRequest, responseAs: Array<T>.self, refreshObjects: refreshObjects, with: core, completion: completion)
        }
    }
    
    private func process<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: Array<T>.Type, refreshObjects: Bool, with core: Core<U>, completion: (() -> Void)?) {
        if let request = urlRequest.urlRequest {
            core.fire(event: Requested(request: request))
        }
        sessionManager.request(urlRequest).responseJSON { response in
            core.fire(event: Responded(url: response.request?.url, status: response.response?.statusCode))
            switch response.result {
            case .success(let responseObject):
                guard let jsonObject = responseObject as? MarshaledObject else {
                    let error = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                    core.fire(event: Errored(error: error))
                    completion?()
                    return
                }
                do {
                    let jsonArray: [MarshaledObject] = try jsonObject.value(for: T.resourceName)
                    let objects: [T] = try jsonArray.compactMap { try T(object: $0) }
                    if refreshObjects {
                        core.fire(event: Refreshed(object: objects))
                    } else {
                        core.fire(event: Loaded(object: objects))
                    }
                } catch {
                    core.fire(event: Errored(error: error))
                }
            case .failure(let error):
                core.fire(event: Errored(error: error))
            }
            completion?()
        }
    }
    
    /// This will call the refresh method of the environment before the request if
    /// the environment requires a refresh before the request. Used for a **list** of
    /// objects, instead of a single object.
    ///
    /// - Parameters:
    ///   - urlRequest: Network request to be made
    ///   - responseAs: Type of response that will be fired into state
    ///   - core: The core object to use in firing events
    ///   - completion: A callback for when the request has completed
    func requestObjects<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: Array<T>.Type, with core: Core<U>, completion: (([T]?, Error?) -> Void)? = nil) {
        guard let protected = environment as? ProtectedAPIEnvironment, protected.forceRefresh else {
            processObjects(urlRequest, responseAs: Array<T>.self, with: core, completion: completion)
            return
        }
        
        protected.refresh { [weak self] success in
            guard let `self` = self else { completion?(nil, nil); return }
            self.refreshComplete()
            self.processObjects(urlRequest, responseAs: Array<T>.self, with: core, completion: completion)
        }
    }
    
    private func processObjects<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: Array<T>.Type, with core: Core<U>, completion: (([T]?, Error?) -> Void)?) {
        if let request = urlRequest.urlRequest {
            core.fire(event: Requested(request: request))
        }
        sessionManager.request(urlRequest).responseJSON { response in
            core.fire(event: Responded(url: response.request?.url, status: response.response?.statusCode))
            switch response.result {
            case .success(let responseObject):
                guard let jsonObject = responseObject as? MarshaledObject else {
                    let error = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                    completion?(nil, error)
                    return
                }
                do {
                    let jsonArray: [MarshaledObject] = try jsonObject.value(for: T.resourceName)
                    let objects: [T] = try jsonArray.compactMap { try T(object: $0) }
                    completion?(objects, nil)
                } catch {
                    completion?(nil, error)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    /// This will call the refresh method of the environment before the request if
    /// the environment requires a refresh before the request. Used for a **single object**
    ///
    /// - Parameters:
    ///   - urlRequest: Network request to be made
    ///   - responseAs: Type of response that will be fired into state
    ///   - core: The core object to use in firing events
    ///   - completion: A callback for when the request has completed
    func requestObject<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: T.Type, with core: Core<U>, completion: ((T?, Error?) -> Void)? = nil) {
        guard let protected = environment as? ProtectedAPIEnvironment, protected.forceRefresh else {
            processObject(urlRequest, responseAs: T.self, with: core, completion: completion)
            return
        }
        
        protected.refresh { [weak self] success in
            guard let `self` = self else { completion?(nil, nil); return }
            self.refreshComplete()
            self.processObject(urlRequest, responseAs: T.self, with: core, completion: completion)
        }
    }
    
    private func processObject<T: UnmarshalingResourceNaming, U>(_ urlRequest: URLRequestConvertible, responseAs: T.Type, with core: Core<U>, completion: ((T?, Error?) -> Void)?) {
        if let request = urlRequest.urlRequest {
            core.fire(event: Requested(request: request))
        }
        sessionManager.request(urlRequest).responseJSON { response in
            core.fire(event: Responded(url: response.request?.url, status: response.response?.statusCode))
            switch response.result {
            case .success(let responseObject):
                guard let jsonObject = responseObject as? JSONObject else {
                    let error = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                    completion?(nil, error)
                    return
                }
                do {
                    let object: T = try T(object: jsonObject)
                    completion?(object, nil)
                } catch {
                    completion?(nil, error)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }

}


class APIEnvironmentAdapter: RequestAdapter {

    let environment: APIEnvironment?

    init(environment: APIEnvironment?) {
        self.environment = environment
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var adapted = urlRequest
        adapted.url = adapted.url?.based(at: environment?.baseURL)
        return adapted
    }

}


class ProtectedAPIEnvironmentAdapter: RequestAdapter {

    let environment: ProtectedAPIEnvironment
    let baseURLAdapter: APIEnvironmentAdapter

    init(environment: ProtectedAPIEnvironment) {
        self.environment = environment
        self.baseURLAdapter = APIEnvironmentAdapter(environment: environment)
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var adapted = try baseURLAdapter.adapt(urlRequest)
        guard let token = environment.bearerToken, !environment.isExpired else { return adapted }
        adapted.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return adapted
    }

}


class APIEnvironmentRetrier: RequestRetrier {

    let environment: APIEnvironment?

    init(environment: APIEnvironment?) {
        self.environment = environment
    }

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(false, 0.0)
    }

}


class PausingSessionDelegate: SessionDelegate {

    var paused: Bool = false {
        didSet {
            if !paused {
                lock.lock() ; defer { lock.unlock() }
                while !pausedRequests.isEmpty {
                    pausedRequests.removeFirst().resume()
                }
            }
        }
    }

    private var pausedRequests = [Request]()
    private let lock = NSLock()

    override open subscript(task: URLSessionTask) -> Request? {
        get {
            return super[task]
        }
        set {
            super[task] = newValue
            if let request = newValue {
                if paused {
                    lock.lock() ; defer { lock.unlock() }
                    pausedRequests.append(request)
                } else {
                    request.resume()
                }
            }
        }
    }

}


protocol ResourceNaming {
    static var resourceName: String { get }
}

typealias UnmarshalingResourceNaming = Unmarshaling & ResourceNaming
