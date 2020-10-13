//
//  ActivityIndicator.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 08.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

/// Индикатор загрузки
public class ActivityIndicator {
    static var activityIndicator: UIActivityIndicatorView?
    static var style: UIActivityIndicatorView.Style = .medium
    static var baseBackColor = UIColor(white: 0, alpha: 0.7)
    static var baseColor = UIColor.white
    static var application = UIApplication.shared

    static func start(style: UIActivityIndicatorView.Style = style,
                      backColor: UIColor = baseBackColor,
                      baseColor: UIColor = baseColor) {
        DispatchQueue.main.async {
            if activityIndicator == nil,
                let window = application.windows.first(where: { $0.isKeyWindow }) {
                let frame = UIScreen.main.bounds
                activityIndicator = UIActivityIndicatorView(frame: frame)

                activityIndicator?.backgroundColor = backColor
                activityIndicator?.style = style
                activityIndicator?.color = baseColor
                guard let activityIndicator = activityIndicator else { return }
                window.addSubview(activityIndicator)
                activityIndicator.startAnimating()
            }
        }
    }

    static func stop() {
        if activityIndicator != nil {
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
                activityIndicator?.removeFromSuperview()
                activityIndicator = nil
            }
        }
    }

    @objc
    static func update() {
        if activityIndicator != nil {
            stop()
            start()
        }
    }
}
