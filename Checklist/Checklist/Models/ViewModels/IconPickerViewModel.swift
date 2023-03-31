//
//  IconPickerViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class IconPickerViewModel {

	private let icons = Icon.allCases

	var iconsCount: Int {
		return icons.count
	}

	// MARK: - Public

	func icon(at indexPath: IndexPath) -> Icon {
		return icons[indexPath.row]
	}

	func cellViewModel(at indexPath: IndexPath) -> IconCellViewModel {
		let name = icons[indexPath.row].rawValue
		return IconCellViewModel(name: name)
	}
}

