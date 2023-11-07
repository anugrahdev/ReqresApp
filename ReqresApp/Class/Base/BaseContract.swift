//
//  BaseContract.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation
import UIKit

protocol BaseViewProtocol: AnyObject {
    
}

protocol BasePresenterProtocol: AnyObject {

}

protocol BaseInteractorProtocol: AnyObject {
    
}

protocol BaseWireframeProtocol: AnyObject {
    
    /// Show or hide activity indicator (custom / default)
    /// - Parameters:
    ///   - isHidden: Set loading visibility
    ///   - indicatorType: Default or shimmer
    func setLoadingIndicator(isHidden: Bool)
    
    /// Show dialog no internet connection
    func showNoInternetAlert()
    
    /// Show alert dialog with
    /// - Parameters:
    ///   - message: Alert message
    ///   - requestType: Failed source
    func showErrorAlert(_ message: String)
}

protocol BaseInteractorDelegate: AnyObject {
    
    /// Assign type based on request use for
    /// - Parameters:
    ///   - error: Error description
    ///   - requestType: Failed source
    func serviceRequestDidFail(_ error: NSError)

}

protocol TableViewCellProtocol: AnyObject {
    static var identifier: String { get }
    static func nib() -> UINib
}

protocol CollectionViewCellProtocol: AnyObject {
    static var identifier: String { get }
    static func nib() -> UINib
}
