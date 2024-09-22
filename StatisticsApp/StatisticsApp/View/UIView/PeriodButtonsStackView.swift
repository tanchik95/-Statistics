//
//  PeriodStackView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 11.09.2024.
//

import UIKit
import PinLayout

class ButtonStackView: UIView {

	var buttons: [UIButton] = []

	var buttonTitles: [String] = [] {
		didSet {
			setupButtons()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButtons()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupButtons()
	}

	private func setupButtons() {
		buttons.forEach { $0.removeFromSuperview() }
		buttons.removeAll()
		for title in buttonTitles {
			let button = UIButton(type: .system)
			button.setTitle(title, for: .normal)
			button.setTitleColor(.black, for: .normal)
			button.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0)
			button.layer.cornerRadius = 16
			button.layer.masksToBounds = true
			button.layer.borderWidth = 1
			button.layer.borderColor = UIColor.systemGray3.cgColor

			button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

			buttons.append(button)
			addSubview(button)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let spacing: CGFloat = 10
		var cumulativeWidth: CGFloat = 0.0

		for button in buttons {
			button.sizeToFit()
			button.pin
				.top()
				.left(cumulativeWidth)
				.height(32)

			cumulativeWidth += button.frame.width + spacing
		}
	}

	@objc private func buttonTapped(_ sender: UIButton) {
		for button in buttons {
			button.setTitleColor(.black, for: .normal)
			button.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0)
			button.layer.borderColor = UIColor.systemGray3.cgColor
			button.layer.borderWidth = 1
		}

		sender.setTitleColor(.white, for: .normal)
		sender.backgroundColor = .red
		sender.layer.borderWidth = 0

	}
}
