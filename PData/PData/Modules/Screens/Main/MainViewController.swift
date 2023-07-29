//
//  MainViewController.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit

final class MainViewController: UIViewController {

    enum Constants {
        static let widthHeader = UIScreen.main.bounds.width
    }

    private var viewModel: MainViewModel

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let footer = ButtonFooterCell(frame: CGRect(x: 0, y: 0, width: Constants.widthHeader, height: 100))

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setuplayout()
    }

    private func setupUI() {
        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        tableView.register(FieldsCell.self, forCellReuseIdentifier: FieldsCell.idCell)
        footer.clearButtonTapped = { [weak self] in
            self?.viewModel.alert()
        }
    }

    private func setuplayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MainHeaderCell(frame: CGRect(x: 0, y: 0, width: MainViewController.Constants.widthHeader, height: 50))

        if section < 1 {
            headerView.configure(
                "Персональные данные",
                buttonIsHedden: true
            )
            return headerView
        } else {
            headerView.configure(
                "Дети (макс. 5)",
                buttonIsHedden: self.viewModel.childrenModul.count > 4 ? true : false
            )
            headerView.addButtonTapped = { [weak self] in
                self?.viewModel.addChildren()
            }
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < 1 ? 1 : viewModel.childrenModul.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.configurationTable(tableView, cellForRowAt: indexPath)
    }
}

extension MainViewController {
    func uptateTable() {
        tableView.tableFooterView = viewModel.childrenModul.isEmpty ? UIView() : footer
        tableView.reloadData()
    }
}

