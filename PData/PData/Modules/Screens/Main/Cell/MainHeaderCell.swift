//
//  MainHeaderCell.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit
import SnapKit

final class MainHeaderCell: UITableViewHeaderFooterView {

    var addButtonTapped: (() -> Void)?

    private let titleLabel = UILabel()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить ребенка", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    init(frame: CGRect) {
        super.init(reuseIdentifier: nil)
        self.frame = frame
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ nameHeader: String, buttonIsHedden: Bool) {
        titleLabel.text = nameHeader
        button.isHidden = buttonIsHedden
    }

    @objc private func buttonTapped() {
        addButtonTapped?()
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        self.addSubviews(titleLabel, button)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.greaterThanOrEqualTo(button.snp.leading)
        }

        button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
