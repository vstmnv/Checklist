//
//  ViewController.swift
//  Checklist
//
//  Created by Vesela Stamenova on 22.11.22.
//

import UIKit
import Combine

protocol ChecklistViewControllerDelegate: AnyObject {
	func checklistViewController(
		_ checklistViewController: ChecklistViewController,
		didUpdate checklist: Checklist,
		at indexPath: IndexPath
	)
}

class ChecklistViewController: UITableViewController {

	private enum Constant {
		static let addItemSegue = "AddItem"
		static let editItemSegue = "EditItem"
	}

	private var viewModel: ChecklistViewModel = ChecklistViewModel(
		checklist: Checklist(name: "", iconName: nil),
		indexPathOfChecklist: IndexPath(row: 0, section: 0)
	)
	private var cancellables: [AnyCancellable] = []

	weak var delegate: ChecklistViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.$checklist
			.receive(on: DispatchQueue.main)
			.sink { [weak self] newChecklist in
				guard let self else {
					return
				}
				self.delegate?.checklistViewController(self, didUpdate: newChecklist, at: self.viewModel.indexPathOfChecklist)
				self.tableView.reloadData()
			}
			.store(in: &cancellables)
	}

	func configure(with viewModel: ChecklistViewModel) {
		self.viewModel = viewModel
		self.title = viewModel.navigationTitle
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case Constant.addItemSegue:
			let controller = segue.destination as? ItemDetailViewController
			controller?.delegate = self
		case Constant.editItemSegue:
			let controller = segue.destination as? ItemDetailViewController
			controller?.delegate = self

			if let tableViewCell = sender as? UITableViewCell,
			   let indexPath = tableView.indexPath(for: tableViewCell) {
				let itemDetailViewModel = ItemDetailViewModel(checklistItem: viewModel.item(at: indexPath), indexPath: indexPath)
				controller?.configure(with: itemDetailViewModel)
			}
		default:
			break
		}
	}

	// MARK: - Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.itemsCount
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.checklistItemIdentifier, for: indexPath) as? ToDoCell else {
			return UITableViewCell()
		}
		let cellViewModel = viewModel.cellViewModel(at: indexPath)
		cell.configure(with: cellViewModel)
		return cell
	}

	// MARK: - Table View Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.toggleItem(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		viewModel.deleteItem(at: indexPath)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
}

// MARK: - ItemDetailViewControllerDelegate

extension ChecklistViewController: ItemDetailViewControllerDelegate {
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
		navigationController?.popViewController(animated: true)
	}

	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
		viewModel.addItem(item)
		navigationController?.popViewController(animated: true)
	}

	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishEditing item: ChecklistItem,
		indexPath: IndexPath
	) {
		viewModel.editItem(item, at: indexPath)
		navigationController?.popViewController(animated: true)
	}
}

