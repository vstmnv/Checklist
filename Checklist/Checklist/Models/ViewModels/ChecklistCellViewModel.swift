//
//  ChecklistCellViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class ChecklistCellViewModel {

	let checklistName: String
	let remainingLabel: String
	let iconName: String?

	init(checklist: Checklist) {
		checklistName = checklist.name
		iconName = checklist.iconName

		let uncheckedItemsCount = checklist.countUncheckedItems()

		if checklist.items.count == 0 {
			remainingLabel = "No items"
		} else if uncheckedItemsCount == 0 {
			remainingLabel = "All Done"
		} else {
			remainingLabel = "\(uncheckedItemsCount) Remaining"
		}
	}
}
