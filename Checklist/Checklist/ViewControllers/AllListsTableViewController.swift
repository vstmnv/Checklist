//
//  AllListsTableViewController.swift
//  Checklist
//
//  Created by Vesela Stamenova on 16.01.23.
//

import UIKit
import Combine

final class AllListsTableViewController: UITableViewController {

	private let viewModel = AllListsViewModel()
	private var cancellables: [AnyCancellable] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.lists
			.receive(on: DispatchQueue.main)
			.sink { [weak self] _ in
				self?.tableView.reloadData()
			}
			.store(in: &cancellables)
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		navigationController?.delegate = self

		if viewModel.shouldShowChecklist {
			performSegue(withIdentifier: "ShowChecklist", sender: viewModel.indexPathOfSelectedChecklist)
		}
	}

	// MARK: - Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.listCount
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.checklistCellIdentifier, for: indexPath) as? ChecklistCell else {
			return UITableViewCell()
		}

		let cellViewModel = viewModel.cellViewModel(at: indexPath)
		cell.configure(with: cellViewModel)

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectIndex(at: indexPath)
		performSegue(withIdentifier: Constants.showChecklistSegue, sender: viewModel.indexPathOfSelectedChecklist)
	}

	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		performSegue(withIdentifier: Constants.editChecklistSegue, sender: indexPath)
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		viewModel.removeList(at: indexPath)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case Constants.showChecklistSegue:
			if let controller = segue.destination as? ChecklistViewController,
			   let indexPath = sender as? IndexPath {
				let checklistViewModel = ChecklistViewModel(
					checklist: viewModel.list(at: indexPath),
					indexPathOfChecklist: indexPath
				)
				controller.configure(with: checklistViewModel)
				controller.delegate = self
			}
		case Constants.addChecklistSegue:
			let controller = segue.destination as? ListDetailViewController
			controller?.delegate = self
		case Constants.editChecklistSegue:
			let controller = segue.destination as? ListDetailViewController
			controller?.delegate = self
			if let indexPath = sender as? IndexPath {
				let listDetailViewModel = ListDetailViewModel(checklist: viewModel.list(at: indexPath), indexPath: indexPath)
				controller?.configure(with: listDetailViewModel)
			}
		default:
			break
		}
	}
}

	// MARK: - ListDetailViewControllerDelegate

extension AllListsTableViewController: ListDetailViewControllerDelegate {
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
		navigationController?.popViewController(animated: true)
	}

	func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
		viewModel.addList(checklist)
		navigationController?.popViewController(animated: true)
	}

	func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist, at indexPath: IndexPath) {
		viewModel.editList(checklist, at: indexPath)
		navigationController?.popViewController(animated: true)
	}
}

	// MARK: - ChecklistViewControllerDelegate

extension AllListsTableViewController: ChecklistViewControllerDelegate {
	func checklistViewController(_ checklistViewController: ChecklistViewController, didUpdate checklist: Checklist, at indexPath: IndexPath) {
		viewModel.updateList(checklist, at: indexPath)
	}
}

	// MARK: - UINavigationControllerDelegate

extension AllListsTableViewController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if viewController === self {
			viewModel.unselectChecklist()
		}
	}
}


