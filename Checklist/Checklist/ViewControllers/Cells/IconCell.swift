//
//  IconCell.swift
//  Checklist
//
//  Created by Vesela Stamenova on 7.02.23.
//

import Foundation
import UIKit

final class IconCell: UITableViewCell {
	@IBOutlet private weak var iconImageView: UIImageView!
	@IBOutlet private weak var iconLabel: UILabel!

	func configure(with cellViewModel: IconCellViewModel) {
		self.iconImageView.image = UIImage(named: cellViewModel.imageName)
		self.iconLabel.text = cellViewModel.name
	}
}
