//
//  LoadingAlert.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class LoadingAlert: NSObject {
    static let sharedInstance = LoadingAlert()
    private var alertController: UIAlertController?
    private var currentViewController: UIViewController?
    
    func showAlertOn(viewController: UIViewController) {
        currentViewController = viewController
        alertController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            URLSession.shared.invalidateAndCancel()
        }))
        currentViewController?.present(alertController!, animated: true, completion: nil)
    }
    
    func dismissAlert(completionBlock: (() -> Void)?) {
        alertController?.dismiss(animated: true, completion: completionBlock)
        alertController = nil
    }
}
