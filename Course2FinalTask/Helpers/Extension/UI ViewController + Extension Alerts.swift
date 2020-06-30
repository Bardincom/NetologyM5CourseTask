//
//  Alerts.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 14.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func displayAlert() {

        let alertController = UIAlertController(title: "Unknown error!",
                                                message: "Please, try again later.",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }

        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction

        present(alertController, animated: false, completion: nil)
    }
}
