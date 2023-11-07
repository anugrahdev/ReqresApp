//
//  LoginInteractorTests.swift
//  ReqresAppTests
//
//  Created by AnangNugraha on 07/11/23.
//

import XCTest
@testable import ReqresApp

final class LoginInteractorTests: XCTestCase {

    var sut: LoginInteractor?
    var mockInteractorDelegate: MockInteractorDelegate?
    var mockRequest:MockRequestRestService!

    override func setUp() {
        super.setUp()
        mockInteractorDelegate = MockInteractorDelegate()
        mockRequest = MockRequestRestService()
        sut = LoginInteractor()
        sut?.delegate  = mockInteractorDelegate
        sut?.request = mockRequest
    }
    
    override func tearDown() {
        mockRequest = nil
        mockInteractorDelegate = nil
        sut = nil
        super.tearDown()
    }
    
    func test_login_success() {
        let mockUsername = "ANANG"
        let mockPassword = "1234567"
        mockRequest.isSuccess = true
        sut?.login(username: mockUsername, password: mockPassword)
        
        XCTAssertEqual(mockInteractorDelegate?.tokenReturn, mockRequest.TOKEN)
    }
    
    func test_login_failed() {
        let mockUsername = "ANANG"
        let mockPassword = "1234567"
        mockRequest.isSuccess = false
        sut?.login(username: mockUsername, password: mockPassword)
        
        XCTAssertEqual(mockInteractorDelegate?.errorMsg, mockRequest.DESC)
    }

}

class MockInteractorDelegate: LoginInteractorDelegate {
    
    var tokenReturn = ""
    var errorMsg = ""
    
    func loginSuccessfull(token: String) {
        tokenReturn = token
    }
    
    func serviceRequestDidFail(_ error: CustomError) {
        errorMsg = error.localizedDescription
    }
}

class MockRequestRestService: RestApiServicesProtocol {
    
    var isSuccess = false
    let DESC = "/Users/anangnugraha/Development/XCodeProjects/UIKit/ReqresApp/ReqresAppTests/LoginInteractorTests.swift"
    let TOKEN = "LoginInteractorTests.swift"
    
    func postLogin<T>(params: [String : String], success: @escaping (T) -> Void, failure: @escaping (CustomError) -> Void) where T : Decodable, T : Encodable {
        if isSuccess {
            let data = LoginResponseModel(token: TOKEN)
            success(data as! T)
        } else {
            failure(CustomError(title: "TITLE", description: DESC, code: 0))
        }
    }
}
