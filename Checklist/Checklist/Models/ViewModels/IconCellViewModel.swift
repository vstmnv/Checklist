//
//  IconCellViewModel.swift
//  Checklist
//
//  Created by Vesela Stamenova on 15.03.23.
//

import Foundation

final class IconCellViewModel {
	let name: String
	let imageName: String

	init(name: String) {
		self.name = name
		self.imageName = name
	}
}
