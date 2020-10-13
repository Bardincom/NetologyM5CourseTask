//
//  Alert.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 06.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

final class Alert {

    /// Выводит предупреждение в случае ошибки при авторизации
    /// - Parameter viewController: передаем контроллер, в котором необходимо показать предупреждение
    /// - Parameter message: передаем сообщение.
    class func showAlert(_ viewController: UIViewController, _ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Localization.Button.ok, style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}
