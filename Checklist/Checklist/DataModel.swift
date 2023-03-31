//
//  DataModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 18.01.23.
//

import Foundation

class DataModel {

	private enum Constant {
		static let checklistIndex = "ChecklistIndex"
		static let checklists = "Checklists"
		static let firstTime = "FirstTime"
	}

	static let shared = DataModel()

	@Published var lists = [Checklist]()
	
	var indexOfSelectedChecklist: Int {
		get {
			return UserDefaults.standard.integer(forKey: Constant.checklistIndex)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Constant.checklistIndex)
		}
	}

	func saveChecklist() {
		do {
			let encodedLists = try JSONEncoder().encode(lists)
			UserDefaults.standard.set(encodedLists, forKey: Constant.checklists)
		} catch {
			print("Error encoding lists: \(error.localizedDescription)")
		}
	}

	func loadChecklist() {
		guard let encodedLists = UserDefaults.standard.data(forKey: Constant.checklists) else {
			return
		}

		do {
			lists = try JSONDecoder().decode([Checklist].self, from: encodedLists)
			sortChecklists()
		} catch {
			print("Error decoding lists: \(error.localizedDescription)")
		}
	}

	func registerDefaults() {
		let dictionary = [ Constant.checklistIndex: -1, Constant.firstTime: true ] as [String: Any]
		UserDefaults.standard.register(defaults: dictionary)
	}

	func handleFirstTime() {
		let userDefaults = UserDefaults.standard
		let firstTime = userDefaults.bool(forKey: Constant.firstTime)

		if firstTime {
			let checklist = Checklist(name: "List", iconName: nil)
			lists.append(checklist)

			indexOfSelectedChecklist = 0
			userDefaults.set(false, forKey: Constant.firstTime)
		}
	}

	func sortChecklists() {
		lists.sort { list1, list2 in
			return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
		}
	}

	private init() {
		loadChecklist()
		registerDefaults()
		handleFirstTime()
	}
}
