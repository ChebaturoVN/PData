//
//  FieldsCell.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit
import SnapKit

struct FieldsCellModel {
    var name: String
    var age: String
    var tag: Int?
}

protocol FieldsCellDelegate: AnyObject {
    func textFieldDidChange(_ indexPath: IndexPath?, name: String?)
    func textFieldDidChange(_ indexPath: IndexPath?, age: String?)
}

final class FieldsCell: UITableViewCell {

    static let idCell = "FieldsCell"

    weak var delegate: FieldsCellDelegate?

    var indexPathCell: IndexPath?

    var delButtonTapped: ((IndexPath?) -> Void)?

    private var model: FieldsCellModel = .init(name: "", age: "", tag: nil)

    private let nameTextField: CustomTextField = {
        let textField = CustomTextField(frame: CGRect())
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        return textField
    }()

    private let ageTextField: CustomTextField = {
        let textField = CustomTextField(frame: CGRect())
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        return textField
    }()

    private var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let separator: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.systemGray6.cgColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setUpLayout()
    }

    func configureCell(_ textInput: ChildrenModul) {

        nameTextField.configure(model: .init(
            nameTitle: "Имя",
            placeholder: "Заполнить",
            textInput: textInput.person.name),
                                type: .name
        )
        ageTextField.configure(model: .init(
            nameTitle: "Возраст",
            placeholder: "Заполнить",
            textInput: textInput.person.age),
                               type: .age
        )
        deleteButton.isHidden = textInput.delButton

        deleteButton.snp.updateConstraints { make in
            make.width.equalTo(deleteButton.isHidden ? 0 : UIScreen.main.bounds.width / 2 - 80)
            make.trailing.equalToSuperview().inset(deleteButton.isHidden ? 20 : 80)
        }
    }

    @objc private func buttonTap() {
        delButtonTapped?(indexPathCell)
    }

    private func setUpUI() {

        nameTextField.delegate = self
        ageTextField.delegate = self

        deleteButton.titleLabel?.textAlignment = .right
        self.contentView.addSubviews(nameTextField, ageTextField, deleteButton, separator)
    }

    private func setUpLayout() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.trailing.greaterThanOrEqualTo(deleteButton.snp.leading)
            make.leading.equalToSuperview().offset(20)
        }
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(nameTextField.snp.trailing)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(nameTextField.snp.height)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.top)
            make.trailing.equalToSuperview().inset(80)
            make.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        separator.snp.makeConstraints { make in
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FieldsCell: MainViewModelImplDelegate {
    func clearAll() {
        nameTextField.clearInputText()
        ageTextField.clearInputText()
    }
}

extension FieldsCell: CustomTextFieldDelegate {
    func textFieldDidChange(text: String?, type: TextFieldType) {
        switch type {
        case .name:
            delegate?.textFieldDidChange(indexPathCell, name: text)
        case .age:
            delegate?.textFieldDidChange(indexPathCell, age: text)

        }
    }
}
