//
//  Alamofire+Marshal.swift
//  align
//
//  Created by Tim on 1/9/18.
//  Copyright © 2018 OC Tanner. All rights reserved.
//

import Alamofire
import Foundation
import Marshal


extension DataRequest {
    @discardableResult
    func responseMarshaled(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MarshaledObject>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<MarshaledObject> { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            guard let validData = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            do {
                let json = try JSONParser.JSONObjectWithData(validData)
                return .success(json)
            } catch {
                return .failure(error)
            }
        }

        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    @discardableResult
    func responseAs<T>(_ type: T.Type, queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self where T: Unmarshaling {
        return responseMarshaled(queue: queue) { marshaledResponse in
            completionHandler(marshaledResponse.as(type))
        }
    }
}


extension DataResponse where Value == MarshaledObject {

    func `as`<T>(_ type: T.Type) -> DataResponse<T> where T: Unmarshaling {
        return self.flatMap { object in
            do {
                return try T(object: object)
            } catch {
                if var adjustedObject = object as? JSONObject, adjustedObject.keys.count == 1, let id = adjustedObject.keys.first {
                    adjustedObject["id"] = id
                    let adjustedJSON: JSONObject = try adjustedObject.value(for: id)
                    return try T(object: adjustedJSON)
                } else {
                    throw error
                }
            }
        }
    }

}
