//
//  GeneralService.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
import AFNetworking

class ResponseSerializer: AFHTTPResponseSerializer {
    override func responseObject(for response: URLResponse?, data: Data?, error: NSErrorPointer) -> Any? {
        return data
    }
}

class GeneralService<T: Codable> {
    private var _baseURL: String! = "https://lingo-server.health.test.act.gov.au/"
    private var _sessionManager: AFHTTPSessionManager!
    internal var microserviceURL: String = "pegacorn/operations/directory/r1"
    internal var subserviceURL: String {
        preconditionFailure("This should be overridden")
    }
    
    fileprivate var AFSM: AFHTTPSessionManager {
        if _sessionManager == nil {
            _sessionManager = AFHTTPSessionManager(baseURL: URL(string: _baseURL))
            _sessionManager.responseSerializer = ResponseSerializer()
        }
        return _sessionManager
    }
    
    fileprivate func GetResource(ID: String, withSuccessCallback success: @escaping (T) -> Void, andFailureCallback failure: @escaping (Error) -> Void) {
        let URL = "\(microserviceURL)/\(subserviceURL)/\(ID)"
        AFSM.get(URL, parameters: [:], headers: [:], progress: nil) { task, value in
            if let itm = value as? Data {
                let decoder = JSONDecoder()
                do {
                    let response: FHIRDirectoryResponse<T> = try decoder.decode(FHIRDirectoryResponse<T>.self, from: itm)
                    success(response.entry)
                } catch {
                    failure(error)
                }
            }
        } failure: { task, err in
            failure(err)
        }
    }
    
    fileprivate func FetchResources(fromURL: String, withSuccessCallback success: @escaping ([T], Int) -> Void, andFailureCallback failure: @escaping (Error?) -> Void) {
        AFSM.get(fromURL, parameters: [:], headers: [:], progress: nil) { task, value in
            if let res = task.response as? HTTPURLResponse {
                let count = res.allHeaderFields["X-Total-Count"] as? Int ?? 0
                if let itm = value as? Data {
                    let decoder = JSONDecoder()
                    do {
                        let response: [T] = try decoder.decode([T].self, from: itm)
                        success(response, count)
                    } catch {
                        failure(error)
                    }
                } else {
                    failure(nil)
                }
            } else {
                failure(nil)
            }
        } failure: { task, err in
            failure(err)
        }
    }
    
    fileprivate func ListResources(page: Int, pageSize: Int, withSuccessCallback success: @escaping ([T], Int) -> Void, andFailureCallback failure: @escaping (Error?) -> Void) {
        FetchResources(fromURL: "\(microserviceURL)/\(subserviceURL)?page=\(page)&pageSize=\(pageSize)", withSuccessCallback: success, andFailureCallback: failure)
    }
    
    fileprivate func QueryResources(query: String, page: Int, pageSize: Int, withSuccessCallback success: @escaping ([T], Int) -> Void, andFailureCallback failure: @escaping (Error?) -> Void) {
        FetchResources(fromURL: "\(microserviceURL)/\(subserviceURL)/search?allName=\(query)&page=\(page)&pageSize=\(pageSize)", withSuccessCallback: success, andFailureCallback: failure)
    }
    
    fileprivate func GetResources(query: String?, page: Int, pageSize: Int, withSuccessCallback success: @escaping ([T], Int) -> Void, andFailureCallback failure: @escaping (Error?) -> Void) {
        if let q = query {
            QueryResources(query: q, page: page, pageSize: pageSize, withSuccessCallback: success, andFailureCallback: failure)
        } else {
            ListResources(page: page, pageSize: pageSize, withSuccessCallback: success, andFailureCallback: failure)
        }
    }
    
}

class MappedService<T: Codable, U>: GeneralService<T>, BaseAPIService {
    typealias ReturnType = U
    func mapObject(item: T) -> U {
        preconditionFailure("Override this")
    }
    func SearchResources(query: String?, page: Int, pageSize: Int, withSuccessCallback success: (([ReturnType], Int) -> Void)?, andFailureCallback failure: ((Error?) -> Void)?) {
        GetResources(query: query, page: page, pageSize: pageSize) { res, totalCount in
            success?(res.map({ itm in
                self.mapObject(item: itm)
            }), totalCount)
        } andFailureCallback: { e in
            failure?(e)
        }

    }
    func FetchResource(ID: String, withSuccessCallback success: ((ReturnType) -> Void)?, andFailureCallback failure: ((Error) -> Void)?) {
        GetResource(ID: ID) { itm in
            success?(self.mapObject(item: itm))
        } andFailureCallback: { e in
            failure?(e)
        }
    }
}

class FavouriteService<T: Codable, U>: MappedService<T, U>, FavouritesQueryService {
    
    var favouritesPath: String { preconditionFailure("Override in deriving class") }
    
    func SearchFavouriteResources(practitionerID: String, query: String?, page: Int, pageSize: Int, withSuccessCallback success: (([ReturnType], Int) -> Void)?, andFailureCallback failure: ((Error?) -> Void)?) {
        let baseURL = "\(microserviceURL)/practitioner/\(practitionerID)/\(favouritesPath)"
        let suffix = "page=\(page)&pageSize=\(pageSize)"
        var URL = "\(baseURL)?\(suffix)"
        if let search = query {
            URL = "\(baseURL)/search?allName=\(search)&\(suffix)"
        }
        FetchResources(fromURL: URL) { list, count in
            success?(list.map({ item in
                self.mapObject(item: item)
            }),count)
        } andFailureCallback: { err in
            failure?(err)
        }
    }
}

class PractitionerAPIService: FavouriteService<FHIRPractitioner, Practitioner> {
    override var subserviceURL: String { "Practitioner" }
    override var favouritesPath: String { "PractitionerFavouritesDetails" }
    override func mapObject(item: FHIRPractitioner) -> Practitioner {
        APIPractitioner(fhirPractitioner: item)
    }
}

class PractitionerRoleAPIService: FavouriteService<FHIRPractitionerRole, PractitionerRole> {
    override var subserviceURL: String { "PractitionerRole" }
    override var favouritesPath: String { "PractitionerRoleFavouritesDetails" }
    override func mapObject(item: FHIRPractitionerRole) -> PractitionerRole {
        APIPractitionerRole(innerPractitionerRole: item)
    }
}

class HealthcareServiceAPIService: FavouriteService<FHIRHealthcareService, HealthcareService> {
    override var subserviceURL: String { "HealthcareService" }
}

typealias BaseAPIService = DataFetchService & DataQueryService
typealias APIWithFavourites = BaseAPIService & FavouritesQueryService

protocol DataFetchService {
    associatedtype ReturnType
    func FetchResource(ID: String, withSuccessCallback success: ((ReturnType) -> Void)?, andFailureCallback failure: ((Error) -> Void)?)
}

protocol DataQueryService {
    associatedtype ReturnType
    func SearchResources(query: String?, page: Int, pageSize: Int, withSuccessCallback success: (([ReturnType], Int) -> Void)?, andFailureCallback failure: ((Error?) -> Void)?)
}

protocol FavouritesQueryService {
    associatedtype ReturnType
    func SearchFavouriteResources(practitionerID: String, query: String?, page: Int, pageSize: Int, withSuccessCallback success: (([ReturnType], Int) -> Void)?, andFailureCallback failure: ((Error?) -> Void)?)
}
