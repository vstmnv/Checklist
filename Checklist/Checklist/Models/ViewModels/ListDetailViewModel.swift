//
//  ListDetailViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class ListDetailViewModel: ObservableObject {

	let checklist: Checklist?
	let indexPath: IndexPath?

	@Published private(set) var isDoneButtonEnabled: Bool
	@Published var selectedIcon: Icon = .folder

	var navigationTitle: String {
		return checklist == nil ? "Add Checklist" : "Edit Checklist"
	}

	init(checklist: Checklist? = nil, indexPath: IndexPath? = nil) {
		self.checklist = checklist
		self.indexPath = indexPath
		self.isDoneButtonEnabled = checklist != nil
	}

	// MARK: - Public

	func setDoneButton(oldText: String, stringRange: Range<String.Index>, replacementString: String) {
		let newText = oldText.replacingCharacters(in: stringRange, with: replacementString)
		isDoneButtonEnabled = !newText.trimmingCharacters(in: .whitespaces).isEmpty
	}

	func getNewChecklist(with text: String) -> Checklist {
		let newChecklist = Checklist(
			name: text,
			iconName: selectedIcon.rawValue,
			items: checklist?.items ?? []
		)
		return newChecklist
	}
}
