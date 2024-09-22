//
//  ProfileListTableDataSource.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 12.09.2024.
//

import UIKit
import PinLayout

// MARK: - Table View Data Source
final class ProfileListTableCell: UITableViewCell {
	override func layoutSubviews() {
		super.layoutSubviews()

		if let imageView = self.imageView {
			imageView.contentMode = .scaleAspectFill
			imageView.clipsToBounds = true

			imageView.pin
				.left(16)
				.center()
				.size(38)
				.layout()
			imageView.layer.cornerRadius = imageView.frame.size.width / 2
			imageView.layer.masksToBounds = true
		}
	}
}

final class ProfileListTableDataSource: NSObject, UITableViewDataSource {
	var data: [User]

	init(data: [User]) {
		self.data = data
	}

	func updateData(with newData: [User]) {
		self.data = newData
	}

	// MARK: - Методы UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? ProfileListTableCell else {
			return UITableViewCell()
		}

		let user = data[indexPath.row]
		let formattedText = "\(user.username), \(user.age) 🍒"
		cell.textLabel?.text = formattedText
		cell.accessoryType = .disclosureIndicator

		if let imageUrlString = user.files.first?.url {
			ImageLoader.loadImage(from: imageUrlString) { [weak cell] image in
				DispatchQueue.main.async {
					guard let updatedCell = cell else { return }
					if tableView.indexPath(for: updatedCell) == indexPath {
						updatedCell.imageView?.image = image
						updatedCell.setNeedsLayout()
					}
				}
			}
		} else {
			cell.imageView?.image = nil
		}
		return cell
	}
}
