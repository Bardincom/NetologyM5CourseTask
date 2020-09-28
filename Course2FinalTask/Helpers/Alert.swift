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
    /// - Parameter massage: передаем сообщение.
    class func showAlert(_ viewController: UIViewController, _ massage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: massage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}
