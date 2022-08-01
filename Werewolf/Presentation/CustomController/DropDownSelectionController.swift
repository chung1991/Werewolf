//
//  RoleSelectionController.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation
import UIKit

protocol DropDownObject {
    var displayString: String { get }
}

protocol DropDownPurpose {
}

struct DefaultDropDownPurpose: DropDownPurpose { }

protocol DropDownSelectionViewModel {
    var purpose: DropDownPurpose? { get set }
    
    var data: [DropDownObject] { get set }
}

struct DropDownSelectionViewModelImpl: DropDownSelectionViewModel {
    var purpose: DropDownPurpose?
    
    var data: [DropDownObject] = []
}

// returnIndexPath is the index of cell that trigger this drop down.
protocol DropDownSelectionDelegate: AnyObject {
    func didSelect(_ object: DropDownObject, _ returnTo: IndexPath, purpose: DropDownPurpose)
}

class DropDownSelectionController: UIViewController {
    lazy var viewModel = DropDownSelectionViewModelImpl()
    lazy var tableView = UITableView()
    weak var delegate: DropDownSelectionDelegate?
    var returnIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayouts()
        setupDelegates()
        reloadData()
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupAutolayouts() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setupDelegates() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(_ returnIndexPath: IndexPath?, _ data: [DropDownObject], purpose: DropDownPurpose = DefaultDropDownPurpose()) {
        self.viewModel.purpose = purpose
        self.viewModel.data = data
        self.returnIndexPath = returnIndexPath
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension DropDownSelectionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = viewModel.data[indexPath.row]
        cell.textLabel?.text = object.displayString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let returnIndexPath = returnIndexPath else {
            print ("can not find return index path")
            return
        }
        guard let purpose = self.viewModel.purpose else {
            print("None purpose")
            return
        }
        let object = viewModel.data[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelect(object, returnIndexPath, purpose: purpose)
        }
    }
}
