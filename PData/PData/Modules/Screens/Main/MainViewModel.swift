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
    func addChildren()
    func configurationTable(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
}

final class MainViewModelImpl: MainViewModel {

    var view: MainViewController?

    var childrenModul = [ChildrenModul]()

    func addChildren() {
        childrenModul.append(.init(
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

}
