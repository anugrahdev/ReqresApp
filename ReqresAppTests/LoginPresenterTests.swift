//
//  LoginPresenterTests.swift
//  ReqresAppTests
//
//  Created by AnangNugraha on 07/11/23.
//

import XCTest
@testable import ReqresApp

final class LoginPresenterTests: XCTestCase {
    
    var sut: LoginPresenter?
    var mockView:MockLoginView?
    var mockInteractor: MockLoginInteractor?
    var mockWireframe: MockLoginWireframe?
    
    override func setUp() {
        super.setUp()
        mockView = MockLoginView()
        mockInteractor = MockLoginInteractor()
        mockWireframe = MockLoginWireframe()
        sut = LoginPresenter(interactor: mockInteractor!, wireframe: mockWireframe!)
        sut?.view = mockView
    }
    
    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockWireframe = nil
        sut = nil
        super.tearDown()
    }
    
    func test_doLogin() {
        let mockUsername = "ANANG"
        let mockPassword = "1234567"
        sut?.doLogin(username: mockUsername, password: mockPassword)
        XCTAssertEqual(mockInteractor?.isLoginSuccessCalled, true)
        XCTAssertEqual(mockInteractor?.userNamePassword, mockUsername+mockPassword)
    }
    
    func test_loginSuccessfull() {
        let token = "XXX"
        sut?.loginSuccessfull(token: token)
        XCTAssertEqual(mockView?.isLoginSuccess, true)
        XCTAssertEqual(mockView?.loginCalled, true)
    }
    
    func test_serviceRequestDidFail() {
        let errMsg = "/Users/anangnugraha/Development/XCodeProjects/UIKit/ReqresApp/ReqresAppTests/LoginPresenterTests.swift"
        sut?.serviceRequestDidFail(CustomError(title: "error", description: "\(errMsg)", code: 404))
        XCTAssertEqual(mockView?.isLoginSuccess, false)
        let expectation = self.expectation(description: "Test async code")
        
        DispatchQueue.main.async { [weak self] in
            XCTAssertEqual(self?.mockWireframe!.errorMsgShowed, errMsg)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
}

class MockLoginView: LoginViewProtocol {
    
    var loginCalled = false
    var isLoginSuccess = false
    
    func loginActionHandler(isSuccess: Bool) {
        loginCalled = true
        isLoginSuccess = isSuccess
    }
}

class MockLoginInteractor: LoginInteractorProtocol {
    
    var isLoginSuccessCalled = false
    var userNamePassword = ""
    
    func login(username: String, password: String) {
        isLoginSuccessCalled = true
        userNamePassword = username + password
    }
}

class MockLoginWireframe: LoginWireframeProtocol {
    
    var errorMsgShowed = ""
    
    func setLoadingIndicator(isHidden: Bool) {
        
    }
    
    func showNoInternetAlert() {
        
    }
    
    func showErrorAlert(_ message: String) {
        errorMsgShowed = message
    }
}
