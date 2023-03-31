//
//  AllListsViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class AllListsViewModel: ObservableObject {

	private let dataModel: DataModel

	var lists: Published<[Checklist]>.Publisher {
		return dataModel.$lists
	}

	var listCount: Int {
		return dataModel.lists.count
	}

	var indexPathOfSelectedChecklist: IndexPath {
		return IndexPath(row: dataModel.indexOfSelectedChecklist, section: 0)
	}

	var shouldShowChecklist: Bool {
		let index = dataModel.indexOfSelectedChecklist
		return index >= 0 && index < dataModel.lists.count
	}

	init(dataModel: DataModel = .shared) {
		self.dataModel = dataModel
	}

	// MARK: - Public

	func selectIndex(at indexPath: IndexPath) {
		dataModel.indexOfSelectedChecklist = indexPath.row
	}

	func unselectChecklist() {
		dataModel.indexOfSelectedChecklist = -1
	}

	func cellViewModel(at indexPath: IndexPath) -> ChecklistCellViewModel {
		return ChecklistCellViewModel(checklist: dataModel.lists[indexPath.row])
	}

	func list(at indexPath: IndexPath) -> Checklist {
		return dataModel.lists[indexPath.row]
	}

	func removeList(at indexPath: IndexPath) {
		dataModel.lists.remove(at: indexPath.row)
	}

	func addList(_ list: Checklist) {
		dataModel.lists.append(list)
		dataModel.sortChecklists()
	}

	func editList(_ list: Checklist, at indexPath: IndexPath) {
		updateList(list, at: indexPath)
		dataModel.sortChecklists()
	}

	func updateList(_ list: Checklist, at indexPath: IndexPath) {
		dataModel.lists.remove(at: indexPath.row)
		dataModel.lists.insert(list, at: indexPath.row)
	}
}
