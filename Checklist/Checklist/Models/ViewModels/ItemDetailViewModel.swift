//
//  ItemDetailViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class ItemDetailViewModel: ObservableObject {

	let checklistItem: ChecklistItem?
	let indexPath: IndexPath?

	@Published private(set) var isDoneButtonEnabled: Bool

	var navigationTitle: String {
		return checklistItem == nil ? "Add Item" : "Edit Item"
	}

	init(checklistItem: ChecklistItem? = nil, indexPath: IndexPath? = nil) {
		self.checklistItem = checklistItem
		self.indexPath = indexPath
		self.isDoneButtonEnabled = checklistItem != nil
	}

	// MARK: - Public

	func setDoneButton(oldText: String, stringRange: Range<String.Index>, replacementString: String) {
		let newText = oldText.replacingCharacters(in: stringRange, with: replacementString)
		isDoneButtonEnabled = !newText.trimmingCharacters(in: .whitespaces).isEmpty
	}
}
