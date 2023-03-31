//
//  itemDetailViewController.swift
//  Checklist
//
//  Created by Vesela Stamenova on 28.11.22.
//

import UIKit
import Combine

protocol ItemDetailViewControllerDelegate: AnyObject {
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishEditing item: ChecklistItem,
		indexPath: IndexPath
	)
}

final class ItemDetailViewController: UITableViewController {

	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var doneBarButton: UIBarButtonItem!

	private var viewModel = ItemDetailViewModel()
	private var cancellables: [AnyCancellable] = []

	weak var delegate: ItemDetailViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = viewModel.navigationTitle
		textField.text = viewModel.checklistItem?.text

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

	func configure(with viewModel: ItemDetailViewModel) {
		self.viewModel = viewModel
	}

	// MARK: - Actions

	@IBAction private func cancel() {
		delegate?.itemDetailViewControllerDidCancel(self)
	}

	@IBAction private func done() {
		guard let text = textField.text else {
			return
		}
		if let item = viewModel.checklistItem, let indexPath = viewModel.indexPath {
			let editedItem = ChecklistItem(text: text, checked: item.checked)
			delegate?.itemDetailViewController(self, didFinishEditing: editedItem, indexPath: indexPath)
		} else {
			let item = ChecklistItem(text: text)
			delegate?.itemDetailViewController(self, didFinishAdding: item)
		}
	}
}

	// MARK: - Text Field Delegates


extension ItemDetailViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let oldText = textField.text, let stringRange = Range(range, in: oldText) else {
			return true
		}

		viewModel.setDoneButton(oldText: oldText,stringRange: stringRange, replacementString: string)
		return true
	}
}
