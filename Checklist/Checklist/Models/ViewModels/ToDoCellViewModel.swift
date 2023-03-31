//
//  ToDoCellViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class ToDoCellViewModel {
	let isCheckmarkHidden: Bool
	let text: String

	init(item: ChecklistItem) {
		isCheckmarkHidden = !item.checked
		text = item.text
	}
}
