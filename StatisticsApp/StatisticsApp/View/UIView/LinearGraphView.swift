//
//  LinearGraphView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 19.09.2024.
//

import UIKit
import PinLayout

class LinearGraphView: UIView {
	private var labels: [String] = []
	private var orangePercentages: [CGFloat] = []
	private var redPercentages: [CGFloat] = []

	private let stackView = UIStackView()

	func configure(labels: [String], orangePercentages: [CGFloat], redPercentages: [CGFloat]) {
		self.labels = labels
		self.orangePercentages = orangePercentages
		self.redPercentages = redPercentages
		setupView()
	}

	private func setupView() {
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 16
		addSubview(stackView)

		for i in 0..<labels.count {
			if i < orangePercentages.count, i < labels.count, i < redPercentages.count {
				let graphRowView = createGraphRow(label: labels[i],
												  orangePercentage: orangePercentages[i],
												  redPercentage: redPercentages[i])
				stackView.addArrangedSubview(graphRowView)
			}
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		stackView.pin.top(10).horizontally(16).bottom(10)
	}

	private func createGraphRow(label: String, orangePercentage: CGFloat, redPercentage: CGFloat) -> UIView {
		let rowView = UIView()
		
		// Метка слева
		let labelView = UILabel()
		labelView.text = label
		labelView.font = UIFont.boldSystemFont(ofSize: 15)
		labelView.textColor = .black
		rowView.addSubview(labelView)

		let minimumBarWidth: CGFloat = 5.0

		let orangeBar = createRoundedBar(color: UIColor.STColor.orangeColor, percentage: max(orangePercentage, minimumBarWidth))
		rowView.addSubview(orangeBar)

		let redBar = createRoundedBar(color: UIColor.STColor.redColor, percentage: max(redPercentage, minimumBarWidth))
		rowView.addSubview(redBar)

		let orangePercentageText = "\(Int(orangePercentage))%"
		let redPercentageText = "\(Int(redPercentage))%"

		let orangePercentageLabel = UILabel()
		orangePercentageLabel.text = orangePercentageText
		orangePercentageLabel.font = UIFont.systemFont(ofSize: 10)
		orangePercentageLabel.textColor = .black
		rowView.addSubview(orangePercentageLabel)

		let redPercentageLabel = UILabel()
		redPercentageLabel.text = redPercentageText
		redPercentageLabel.font = UIFont.systemFont(ofSize: 10)
		redPercentageLabel.textColor = .black
		rowView.addSubview(redPercentageLabel)

		rowView.pin.height(40)
		
		labelView.pin.left(0).vCenter().sizeToFit()
		orangeBar.pin.right(of: labelView, aligned: .center).marginLeft(31).height(5)
		redBar.pin.below(of: orangeBar).marginTop(4).right(of: labelView, aligned: .center).marginLeft(31).height(5)

		orangeBar.pin.width(max(orangePercentage, minimumBarWidth))
		redBar.pin.width(max(redPercentage, minimumBarWidth))
		redBar.pin.below(of: orangeBar).marginTop(8).height(5) // Отступ 5 между графиками

		orangePercentageLabel.pin.right(of: orangeBar, aligned: .center).marginLeft(10).sizeToFit()
		redPercentageLabel.pin.right(of: redBar, aligned: .center).marginLeft(10).sizeToFit()

		return rowView
	}

	private func createRoundedBar(color: UIColor, percentage: CGFloat) -> UIView {
		let barView = UIView()
		barView.backgroundColor = color
		barView.layer.cornerRadius = 3
		return barView
	}
}
