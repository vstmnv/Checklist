//
//  Checklist.swift
//  Checklist
//
//  Created by Vesela Stamenova on 16.01.23.
//

import UIKit

struct Checklist: Codable {
	let name: String
	let items: [ChecklistItem]
	let iconName: String?

	init(name: String, iconName: String?, items: [ChecklistItem] = []) {
		self.name = name
		self.items = items
		self.iconName = iconName
	}

	func countUncheckedItems() -> Int {
		return items.filter { !$0.checked }.count
	}
}
