//
//  ButtonFooterCell.swift
//  PData
//
//  Created by VladimirCH on 29.07.2023.
//

import UIKit

final class ButtonFooterCell: UITableViewHeaderFooterView {

    var clearButtonTapped: (() -> Void)?

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .red
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.red.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 40, bottom: 8, right: 40)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    init(frame: CGRect) {
        super.init(reuseIdentifier: nil)
        self.frame = frame

        button.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(buttonIsHedden: Bool) {
        button.isHidden = buttonIsHedden
    }

    @objc private func clearButtonTap() {
        clearButtonTapped?()
    }

    private func setupLayout() {
        self.addSubviews(button)

        button.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
    }
}
