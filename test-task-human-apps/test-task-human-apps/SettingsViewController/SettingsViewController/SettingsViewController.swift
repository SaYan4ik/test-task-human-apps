//
//  SettingsViewController.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit


class SettingsViewController: UIViewController {
// MARK: - Properties
    private let viewModel: SettingsViewModel
    private let dataSource = UniversalTableViewDataSource()
    
// MARK: - UI Elements
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Theme.backgroundPrimary
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50 
        return tableView
    }()
    
// MARK: - Initialization
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registrationTableviewCells()
        setupData()
    }
    
// MARK: - Setup Views Methods
    private func setupViews() {
        view.addSubview(tableView)
        setupConstraints()
        setupNavigationBar(title: "Settings")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupData() {
        dataSource.updateData([AboutAppModel(title: "About App")])
        tableView.reloadData()
    }
    
    private func registrationTableviewCells() {
        tableView.register(
            AboutAppTableViewCell.self,
            forCellReuseIdentifier: "AboutAppTableViewCell"
        )
    }
}

//MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let cellData = dataSource.data[indexPath.row]
        
        if cellData is AboutAppModel {
            showAlert(
                title: "Test app completed by:",
                message: "Alexander Yanchick"
            )
        }
        
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
