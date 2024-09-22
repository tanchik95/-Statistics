//
//  ProfileListView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 11.09.2024.
//

import UIKit
import PinLayout

class ProfileListView: UIView {

	private let profiles: [(image: UIImage, name: String, age: Int, emoji: String)] = []

	private var rows: [UIView] = []

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}

	private func setupUI() {
		for profile in profiles {
			let row = createProfileRow(image: profile.image, name: profile.name, age: profile.age, emoji: profile.emoji)
			addSubview(row)
			rows.append(row)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let rowHeight: CGFloat = 62
		let verticalSpacing: CGFloat = 0

		for (index, row) in rows.enumerated() {
			row.pin.top(CGFloat(index) * (rowHeight + verticalSpacing)).horizontally(16).height(rowHeight)
		}
	}

	private func createProfileRow(image: UIImage, name: String, age: Int, emoji: String) -> UIView {
		let container = UIView()
		container.backgroundColor = .white

		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 25
		imageView.layer.masksToBounds = true
		container.addSubview(imageView)

		let nameLabel = UILabel()
		nameLabel.text = "\(name), \(age)"
		nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
		nameLabel.textColor = .black
		container.addSubview(nameLabel)

		let emojiLabel = UILabel()
		emojiLabel.text = emoji
		emojiLabel.font = UIFont.systemFont(ofSize: 20)
		container.addSubview(emojiLabel)

		let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
		arrowImageView.tintColor = .gray
		container.addSubview(arrowImageView)

		imageView.pin.left(8).vCenter().width(50).height(50)
		nameLabel.pin.after(of: imageView).marginLeft(10).vCenter().sizeToFit()
		emojiLabel.pin.after(of: nameLabel).marginLeft(5).vCenter().sizeToFit()
		arrowImageView.pin.right(8).vCenter().sizeToFit()

		return container
	}
}
