//
//  MainViewModel.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import Foundation
import UIKit

struct ChildrenModul {
    var person: FieldsCellModel
    var delButton: Bool
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

    var parentModul: ChildrenModul = .init(person: .init(name: "", age: ""), delButton: true)
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
            .init(person: .init(name: "", age: "", tag: childrenModul.count ), delButton: false)
        )
        view?.uptateTable()
    }

    func configurationTable(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: FieldsCell.idCell, for: indexPath) as? FieldsCell ?? FieldsCell()
        delegate = cell
        if indexPath.section == 0 {
            cell.configureCell(parentModul)

        } else if !childrenModul.isEmpty && indexPath.section == 1 {
            cell.configureCell(childrenModul[indexPath.row])


        }
        cell.delegate = self

        cell.separator.isHidden = (indexPath.row == childrenModul.count - 1 || indexPath.section == 0) ? true : false
        cell.indexPathCell = indexPath
        cell.delButtonTapped = { [weak self] indexPath in
            guard let indexPath = indexPath else { return }
            self?.deleteCell(tableView, at: indexPath)
        }
        return cell
    }

    private func deleteCell(_ tableView: UITableView, at indexPath: IndexPath) {
        
        childrenModul.remove(at: indexPath.row)
        childrenModul.enumerated().forEach { index, child in
            if let tag = child.person.tag, tag > indexPath.row {
                childrenModul[index].person.tag = tag - 1
            }
        }
        tableView.deleteRows(at: [indexPath], with: .fade)

        view?.uptateTable()
    }

    private func clearData() {
        delegate?.clearAll()
        childrenModul = []
        parentModul = .init(person: .init(name: "", age: ""), delButton: true)
        view?.uptateTable()
    }

}

extension MainViewModelImpl: FieldsCellDelegate {

    func textFieldDidChange(_ indexPath: IndexPath?, name: String?) {
        if let indexPath = indexPath,
           indexPath.section > 0 {
            childrenModul[indexPath.row].person.name = name ?? ""
        } else if let indexPath = indexPath,
                  indexPath.section ==  0 {
            parentModul.person.name = name ?? ""

        }
    }

    func textFieldDidChange(_ indexPath: IndexPath?, age: String?) {
        if let indexPath = indexPath,
           indexPath.section > 0 {
            childrenModul[indexPath.row].person.age = age ?? ""
        } else if let indexPath = indexPath,
                  indexPath.section ==  0 {
            parentModul.person.age = age ?? ""

        }
    }
}
