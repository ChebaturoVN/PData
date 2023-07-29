//
//  MainViewModel.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import Foundation
import UIKit

struct ChildrenModul {
    let name: ModelTextField
    let age: ModelTextField
    let delButton: Bool
}

protocol MainViewModel {
    var view: MainViewController? { get set }
    var childrenModul: [ChildrenModul] { get set }
    func alert()
    func addChildren()
    func configurationTable(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

protocol MainViewModelImplDelegate: AnyObject {
    func clearAll()
}

final class MainViewModelImpl: MainViewModel {

    var view: MainViewController?

    weak var delegate: MainViewModelImplDelegate?

    var childrenModul = [ChildrenModul]()

    func alert() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let clearAction = UIAlertAction(
            title: "Сбросить данные",
            style: .default
        ) { _ in
            self.clearData()
        }

        let cancel = UIAlertAction(
            title: "Отмена",
            style: .cancel)

        alert.addAction(clearAction)
        alert.addAction(cancel)
        view?.present(alert, animated: true, completion: nil)
    }

    func addChildren() {
        childrenModul.append(
            .init(
                name: .init(nameTitle: "Имя",
                            placeholder: "Заполнить"),
                age: .init(nameTitle: "Возраст",
                           placeholder: "Заполнить"),
                delButton: false)
        )
        view?.uptateTable()
    }

    func configurationTable(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: FieldsCell.idCell, for: indexPath) as? FieldsCell ?? FieldsCell()
        if indexPath.section == 0 {
            cell.configureCell(.init(
                name: .init(nameTitle: "Имя",
                            placeholder: "Заполнить"),
                age: .init(nameTitle: "Возраст",
                           placeholder: "Заполнить"),
                delButton: true)
            )
            delegate = cell
        } else if !childrenModul.isEmpty && indexPath.section == 1 {
            cell.configureCell(childrenModul[indexPath.row])
        }
        cell.separator.isHidden = (indexPath.row == childrenModul.count - 1 || indexPath.section == 0) ? true : false
        cell.tag = indexPath.row
        cell.delButtonTapped = { [weak self] tag in
            self?.deleteCell(tableView, at: tag)
        }
        return cell
    }

    private func deleteCell(_ tableView: UITableView, at row: Int) {
        childrenModul.remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: 1)], with: .fade)
        view?.uptateTable()
    }

    private func clearData() {
        delegate?.clearAll()
        childrenModul = []
        view?.uptateTable()
    }

}
