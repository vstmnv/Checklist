//
//  ListDetailViewController.swift
//  Checklist
//
//  Created by Vesela Stamenova on 17.01.23.
//

import UIKit
import Combine

protocol ListDetailViewControllerDelegate: AnyObject {
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
	func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist)
	func listDetailViewController(
		_ controller: ListDetailViewController,
		didFinishEditing item: Checklist,
		at indexPath: IndexPath
	)
}

final class ListDetailViewController: UITableViewController {
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var doneBarButton: UIBarButtonItem!
	@IBOutlet private weak var iconImageView: UIImageView!

	private var viewModel = ListDetailViewModel()
	private var cancellables: [AnyCancellable] = []

	weak var delegate: ListDetailViewControllerDelegate?
	private var checklistToEdit: Checklist?
	private var indexPathToEdit: IndexPath?
	private var selectedIcon: Icon? = .folder

	override func viewDidLoad() {
		super.viewDidLoad()

		title = viewModel.navigationTitle
		textField.text = viewModel.checklist?.name

		viewModel.$selectedIcon
			.receive(on: DispatchQueue.main)
			.sink { [weak self] icon in
				self?.iconImageView.image = icon.image
			}
			.store(in: &cancellables)

		viewModel.$isDoneButtonEnabled
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				self?.doneBarButton.isEnabled = isEnabled
			}
			.store(in: &cancellables)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case Constants.chooseIconSegue:
			let viewController = segue.destination as? IconPickerViewController
			viewController?.delegate = self
		default:
			break
		}
	}

	func configure(with viewModel: ListDetailViewModel) {
		self.viewModel = viewModel
	}

	// MARK: - Actions

	@IBAction private func cancel() {
		delegate?.listDetailViewControllerDidCancel(self)
	}

	@IBAction private func done() {
		guard let text = textField.text else {
			return
		}

		let newChecklist = viewModel.getNewChecklist(with: text)

		if let indexPath = viewModel.indexPath {
			delegate?.listDetailViewController(self, didFinishEditing: newChecklist, at: indexPath)
		} else {
			delegate?.listDetailViewController(self, didFinishAdding: newChecklist)
		}
	}
}
	// MARK: - IconPickerViewControllerDelegate

extension ListDetailViewController: IconPickerViewControllerDelegate {
	func iconPicker(_ picker: IconPickerViewController, didPick icon: Icon) {
		viewModel.selectedIcon = icon
		navigationController?.popViewController(animated: true)
	}
}

	// MARK: - UITextFieldDelegate

extension ListDetailViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let oldText = textField.text, let stringRange = Range(range, in: oldText) else {
			return true
		}
		viewModel.setDoneButton(oldText: oldText, stringRange: stringRange, replacementString: string)
		return true
	}
}
