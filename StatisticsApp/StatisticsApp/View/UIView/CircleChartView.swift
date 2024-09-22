//
//  CircleChartView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 14.09.2024.
//


import UIKit

class CircleChartView: UIView {
	private let lineWidth: CGFloat = 8
	private let gapAngle: CGFloat = 0.2


	func setupChart(manPercentage: Double, womanPercentage: Double) {
		self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

		guard manPercentage + womanPercentage <= 100 else { return }

		let radius = (min(bounds.width, bounds.height) - lineWidth) / 2

		let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)

		let totalAngle = Double.pi * 2
		let manAngle = totalAngle * (manPercentage / 100)
		let womanAngle = totalAngle * (womanPercentage / 100)

		var startAngle = -Double.pi / 2

		let endAngleMan = startAngle + manAngle - gapAngle
		let manPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngleMan, clockwise: true)
		let manLayer = createSegmentLayer(path: manPath, color: UIColor.orange.cgColor, lineWidth: lineWidth)
		self.layer.addSublayer(manLayer)

		startAngle = endAngleMan + gapAngle

		let endAngleWoman = startAngle + womanAngle - gapAngle
		let womanPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngleWoman, clockwise: true)
		let womanLayer = createSegmentLayer(path: womanPath, color: UIColor.red.cgColor, lineWidth: lineWidth)
		self.layer.addSublayer(womanLayer)
	}

	private func createSegmentLayer(path: UIBezierPath, color: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		layer.strokeColor = color
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = lineWidth
		layer.lineCap = .round
		return layer
	}
}
