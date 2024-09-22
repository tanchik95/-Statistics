//
//  PercentageView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 19.09.2024.
//

import UIKit
import PinLayout

class PercentageView: UIView {

	private let maleLabel = UILabel()
	private let femaleLabel = UILabel()
	private let maleDotView = UIView()
	private let femaleDotView = UIView()

	private let malePercentage: CGFloat = 0.4
	private let femalePercentage: CGFloat = 0.6

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

	private func setupView() {
		maleLabel.text = "Мужчины \(Int(malePercentage * 100))%"
		maleLabel.font = UIFont.systemFont(ofSize: 13)
		maleLabel.textColor = .black

		femaleLabel.text = "Женщины \(Int(femalePercentage * 100))%"
		femaleLabel.font = UIFont.systemFont(ofSize: 13)
		femaleLabel.textColor = .black

		maleDotView.backgroundColor = UIColor.STColor.redColor
		maleDotView.layer.cornerRadius = 5
		maleDotView.layer.masksToBounds = true

		femaleDotView.backgroundColor = UIColor.STColor.orangeColor
		femaleDotView.layer.cornerRadius = 5
		femaleDotView.layer.masksToBounds = true

		addSubview(maleLabel)
		addSubview(femaleLabel)
		addSubview(maleDotView)
		addSubview(femaleDotView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		maleDotView.pin.left(40).top(20).size(10)
		maleLabel.pin.after(of: maleDotView, aligned: .center).marginLeft(10).sizeToFit()

		femaleDotView.pin.after(of: maleLabel, aligned: .center).marginLeft(72).size(10)
		femaleLabel.pin.after(of: femaleDotView, aligned: .center).marginLeft(10).sizeToFit()
	}

	private func createCircularProgressLayer(strokeColor: UIColor, startAngle: CGFloat, endAngle: CGFloat) -> CAShapeLayer {
		let circularPath = UIBezierPath(arcCenter: .zero, radius: 90, startAngle: startAngle, endAngle: endAngle, clockwise: true)

		let shapeLayer = CAShapeLayer()
		shapeLayer.path = circularPath.cgPath
		shapeLayer.strokeColor = strokeColor.cgColor
		shapeLayer.lineWidth = 15
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineCap = .round
		shapeLayer.position = CGPoint(x: 100, y: 100)

		return shapeLayer
	}
}
