//
//  Icons.swift
//  Checklist
//
//  Created by Vesela Stamenova on 6.02.23.
//

import Foundation
import UIKit

enum Icon: String, CaseIterable {
	case birthdays = "Birthdays"
	case drinks = "Drinks"
	case groceries = "Groceries"
	case chores = "Chores"
	case folder = "Folder"
	case appointments = "Appointments"
	case inbox = "Inbox"
	case photos = "Photos"
	case trips = "Trips"
	

	var image: UIImage? {
		return UIImage(named: self.rawValue)
	}
}
