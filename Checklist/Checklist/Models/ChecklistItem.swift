//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Vesela Stamenova on 23.11.22.
//

import Foundation

struct ChecklistItem: Codable {
	let text: String
	let checked: Bool

	init(text: String, checked: Bool = false) {
		self.text = text
		self.checked = checked
	}
}
