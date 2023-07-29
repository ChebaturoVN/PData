//
//  UIView+AddSubviews.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit

extension UIView {

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
