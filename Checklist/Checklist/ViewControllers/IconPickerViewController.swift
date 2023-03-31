//
//  IconPickerViewController.swift
//  Checklist
//
//  Created by Vesela Stamenova on 7.02.23.
//

import Foundation
import UIKit
import Combine

protocol IconPickerViewControllerDelegate: AnyObject {
	func iconPicker(_ picker: IconPickerViewController, didPick icon: Icon)
}

class IconPickerViewController: UITableViewController {

	private let viewModel = IconPickerViewModel()

	weak var delegate: IconPickerViewControllerDelegate?

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.iconsCount
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconCellIdentifier, for: indexPath) as? IconCell else {
			return UITableViewCell()
		}

		let cellViewModel = viewModel.cellViewModel(at: indexPath)
		cell.configure(with: cellViewModel)

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let icon = viewModel.icon(at: indexPath)
		delegate?.iconPicker(self, didPick: icon)
	}
}
