//
//  ToDoCell.swift
//  Checklist
//
//  Created by Vesela Stamenova on 5.12.22.
//

import Foundation
import UIKit

final class ToDoCell: UITableViewCell {

	@IBOutlet private weak var checkmarkLabel: UILabel!
	@IBOutlet private weak var cellText: UILabel!

	func configure(with cellViewModel: ToDoCellViewModel) {
		checkmarkLabel.isHidden = cellViewModel.isCheckmarkHidden
		cellText.text = cellViewModel.text
	}
}
