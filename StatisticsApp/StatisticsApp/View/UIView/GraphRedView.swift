//
//  GraphRedView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 11.09.2024.
//

import UIKit
import PinLayout

class GraphRedView: UIView {

	let tooltipView = UIView()
	let tooltipTitleLabel = UILabel()
	let tooltipDateLabel = UILabel()

	let graphLineView = UIView()

	var dateLabels: [UILabel] = []

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}

	private func setupUI() {
		tooltipView.backgroundColor = .white
		tooltipView.layer.cornerRadius = 8
		tooltipView.layer.borderWidth = 1
		tooltipView.layer.borderColor = UIColor.systemGray5.cgColor
		addSubview(tooltipView)

		tooltipTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
		tooltipTitleLabel.textColor = .red
		tooltipView.addSubview(tooltipTitleLabel)

		tooltipDateLabel.font = UIFont.systemFont(ofSize: 13)
		tooltipDateLabel.textColor = .gray
		tooltipView.addSubview(tooltipDateLabel)

		graphLineView.backgroundColor = .clear
		addSubview(graphLineView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		tooltipView.frame = CGRect(x: 27, y: 9, width: 128, height: 72)

		tooltipTitleLabel.frame = CGRect(x: 8, y: 14, width: tooltipView.bounds.width - 16, height: 20)
		tooltipDateLabel.frame = CGRect(x: 8, y: tooltipTitleLabel.frame.maxY + 8, width: tooltipView.bounds.width - 16, height: 20)

		graphLineView.frame = CGRect(x: 10, y: tooltipView.frame.maxY + 10, width: bounds.width - 20, height: 100)

		let labelWidth: CGFloat = frame.width / CGFloat(dateLabels.count)
		for (index, label) in dateLabels.enumerated() {
			label.frame = CGRect(x: CGFloat(index) * labelWidth, y: graphLineView.frame.maxY + 8, width: labelWidth, height: 20)
		}
	}

	func updateTooltip(title: String, date: String) {
		tooltipTitleLabel.text = title
		tooltipDateLabel.text = date
		tooltipView.isHidden = false
	}
}

