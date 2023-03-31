//
//  ChecklistCell.swift
//  Checklist
//
//  Created by Vesela Stamenova on 3.02.23.
//

import Foundation
import UIKit

final class ChecklistCell: UITableViewCell {

	@IBOutlet private weak var remainingLabel: UILabel!
	@IBOutlet private weak var checklistName: UILabel!
	@IBOutlet private weak var imageViewChecklist: UIImageView!

	func configure(with cellViewModel: ChecklistCellViewModel) {
		self.checklistName.text = cellViewModel.checklistName
		self.remainingLabel.text = cellViewModel.remainingLabel
		if let iconName = cellViewModel.iconName {
			imageViewChecklist.image = UIImage(named: iconName)
		}
	}
}
