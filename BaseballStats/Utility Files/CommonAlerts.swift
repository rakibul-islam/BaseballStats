//
//  CommonAlerts.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class CommonAlerts {
    static let sharedInstance = CommonAlerts()
    private var loadingAlertController: UIAlertController?
    private var currentViewController: UIViewController?
    
    func showLoadingAlertOn(viewController: UIViewController) {
        currentViewController = viewController
        loadingAlertController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        loadingAlertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        currentViewController?.present(loadingAlertController!, animated: true, completion: nil)
    }
    
    func dismissLoadingAlert(completionBlock: (() -> Void)?) {
        loadingAlertController?.dismiss(animated: true, completion: completionBlock)
        loadingAlertController = nil
    }
    
    static func showErrorAlertOn(viewController: UIViewController, messageString: String?, error: Error?) {
        var message = "Please try again."
        if let messageStr = messageString {
            message = messageStr
        } else if let theError = error {
            message = theError.localizedDescription
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
