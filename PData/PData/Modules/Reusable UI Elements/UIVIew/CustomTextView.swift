//
//  CustomTextView.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit
import SnapKit

struct ModelTextField {
    let nameTitle: String
    let placeholder: String
    let textInput: String
}

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidChange(text: String?, type: TextFieldType)
}

enum TextFieldType {
    case name
    case age
}

final class CustomTextField: UIView {

    weak var delegate: CustomTextFieldDelegate?

    private let titleLabel: UILabel = UILabel()

    private let inputTextField = UITextField()

    private var type: TextFieldType = .name

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpLayout()
    }

    public func configure(model: ModelTextField, type: TextFieldType) {
        self.type = type
        titleLabel.text = model.nameTitle
        inputTextField.placeholder = model.placeholder
        inputTextField.text = model.textInput
    }

    public func clearInputText() {
        inputTextField.text = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        inputTextField.delegate = self
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = UIColor.systemGray3
        addSubviews(titleLabel, inputTextField)
    }

    private func setUpLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalToSuperview().inset(10)
        }
    }

}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidChange( text: inputTextField.text, type: self.type)
    }
}
