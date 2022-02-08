//
//  HomeService.swift
//  Home
//
//  Created by Johan Torell on 2021-02-08.
//

import Foundation

// MARK: - User

public protocol ParentUser: User, Person {}

// MARK: - HomeUser

public protocol User {
    var email: String? { get }
    var telephone: String? { get }
    var customernumber: String? { get }
    var postalcode: String? { get }
    var street: String? { get }
    var subregion: String? { get }
}

public struct DefaultUser: ParentUser {
    public var firstname: String?
    public var surname: String?
    public var email: String?
    public var telephone: String?
    public var customernumber: String?
    public var postalcode: String?
    public var street: String?
    public var subregion: String?
}

// MARK: - Person

public protocol Person {
    var firstname: String? { get }
    var surname: String? { get }
}

public struct DefaultPerson: ParentUser {
    public var email: String?
    public var telephone: String?
    public var customernumber: String?
    public var postalcode: String?
    public var street: String?
    public var subregion: String?
    public var firstname: String?
    public var surname: String?
}

public protocol HomeServiceProtocol {
    func getUser(resultHandler: @escaping (Result<ParentUser, Error>) -> Void)
    func getPolicies(resultHandler: @escaping (Result<[Policy], Error>) -> Void)
    func getUserAndPolicies(resultHandler: @escaping (Result<(ParentUser, [Policy]), Error>) -> Void)
}

// MARK: - Policy

public protocol Policy {
    var policyId: String? { get }
    var groupPolicyId: String? { get }
    var product: String? { get }
    var annullmentDate: String? { get }
    var validToDate: String? { get }
    var endedReasonText: String? { get }
    var elements: [String]? { get }
    var insuredObject: String? { get }
    var premium: Int? { get }
    var premiumPeriod: String? { get }
    var groupName: String? { get }
}

// MARK: - Mocks

#if !os(macOS)
public struct HomeServiceMock: HomeServiceProtocol {
    
    public func getUser(resultHandler: @escaping (Result<ParentUser, Error>) -> Void) {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            resultHandler(.success(UserMock()))
        }
    }

    public func getPolicies(resultHandler: @escaping (Result<[Policy], Error>) -> Void) {
        let policies = stride(from: 1, through: 10, by: 1).map { i in
            PolicyMock(policyId: "\(i)")
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            resultHandler(.success(policies))
        }
    }

    public func getUserAndPolicies(resultHandler: @escaping (Result<(ParentUser, [Policy]), Error>) -> Void) {
        let policies = stride(from: 1, through: 10, by: 1).map { i in
            PolicyMock(policyId: "\(i)")
        }

        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            resultHandler(.success((UserMock(), policies)))
        }
    }
    
    public init() {}
}

public struct UserMock: ParentUser {
    public var email: String? = "ddad@add.com"
    public var telephone: String? = "0708111111"
    public var customernumber: String? = "PBB012195"
    public var firstname: String? = "Kurt"
    public var surname: String? = "Wretman"
    public var postalcode: String? = "12054"
    public var street: String? = "Streetgatan 14"
    public var subregion: String? = "Stockholm"
    public init() {}
}

public struct PolicyMock: Policy {
    public var insuredObject: String? = "Medlem"
    public var premium: Int? = 300
    public var premiumPeriod: String? = "YEARLY"
    public var policyId: String? = "aaaa"
    public var groupPolicyId: String? = "1"
    public var product: String? = "Gravidförsäkring"
    public var annullmentDate: String? = nil
    public var validToDate: String? = "2022-01-01"
    public var endedReasonText: String? = nil
    public var elements: [String]? = nil
    public var groupName: String? = "via Folksams hemförsäkring Stor för anställda"
    public init(policyId: String) {
        self.policyId = policyId
    }
}
#endif
