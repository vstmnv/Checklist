//
//  ChecklistViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class ChecklistViewModel: ObservableObject {

	@Published private(set) var checklist: Checklist
	let indexPathOfChecklist: IndexPath

	var navigationTitle: String {
		return checklist.name
	}

	var itemsCount: Int {
		return checklist.items.count
	}

	init(checklist: Checklist, indexPathOfChecklist: IndexPath) {
		self.checklist = checklist
		self.indexPathOfChecklist = indexPathOfChecklist
	}

	// MARK: - Public

	func cellViewModel(at indexPath: IndexPath) -> ToDoCellViewModel {
		return ToDoCellViewModel(item: checklist.items[indexPath.row])
	}

	func item(at indexPath: IndexPath) -> ChecklistItem {
		return checklist.items[indexPath.row]
	}

	func toggleItem(at indexPath: IndexPath) {
		let oldItem = checklist.items[indexPath.row]
		let newItem = ChecklistItem(text: oldItem.text, checked: !oldItem.checked)
		var newItems = checklist.items
		newItems.remove(at: indexPath.row)
		newItems.insert(newItem, at: indexPath.row)
		checklist = Checklist(name: checklist.name, iconName: checklist.iconName, items: newItems)
	}

	func deleteItem(at indexPath: IndexPath) {
		var newItems = checklist.items
		newItems.remove(at: indexPath.row)
		checklist = Checklist(name: checklist.name, iconName: checklist.iconName, items: newItems)
	}

	func addItem(_ item: ChecklistItem) {
		var newItems = checklist.items
		newItems.append(item)
		checklist = Checklist(name: checklist.name, iconName: checklist.iconName, items: newItems)
	}

	func editItem(_ item: ChecklistItem, at indexPath: IndexPath) {
		var newItems = checklist.items
		newItems.remove(at: indexPath.row)
		newItems.insert(item, at: indexPath.row)
		checklist = Checklist(name: checklist.name, iconName: checklist.iconName, items: newItems)
	}
}
