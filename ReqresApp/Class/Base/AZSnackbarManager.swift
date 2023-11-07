//
//  AZSnackbarManager.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation
import UIKit

open
class AZSnackbarManager : NSObject {

  public
  static let shared = AZSnackbarManager()

  private
  override init() {}

  private
  var queuedSnackbars: [AZSnackbar] = []

  public
  func show(snackbar: AZSnackbar) {

    func addDismissBlock() {

      let existingSnackbarDismiss = snackbar.dismissCompletion
      snackbar.dismissCompletion = { [weak self] _ in
        var nextSnackbar: AZSnackbar?

        guard let wself = self else {
          return
        }

        if wself.queuedSnackbars.count > 1 {
          nextSnackbar = wself.queuedSnackbars[1]
        }

        existingSnackbarDismiss?(snackbar)

        nextSnackbar?.show()

        _ = wself.queuedSnackbars.removeFirst()
      }
    }

    queuedSnackbars.append(snackbar)

    if queuedSnackbars.count <= 1 {
      addDismissBlock()
      snackbar.show()
    } else {
      let activeSnackbar = self.queuedSnackbars[0]

      let activeSnackbarDismissCompletion = activeSnackbar.dismissCompletion

      activeSnackbar.dismissCompletion = { _ in
        addDismissBlock()
        activeSnackbarDismissCompletion?(activeSnackbar)
      }
    }
  }
}

public
func showSnackbar(_ msg: String) {
  let snackbar: AZSnackbar = AZSnackbar.init(message: msg, duration: .middle)
  snackbar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
  snackbar.leftMargin = 8
  snackbar.rightMargin = 8
  snackbar.snackbarMaxWidth = UIScreen.main.bounds.width*0.75
  snackbar.position = .top

  AZSnackbarManager.shared.show(snackbar: snackbar)
}
