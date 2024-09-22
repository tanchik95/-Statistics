//
//  VisitorChartView.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 11.09.2024.
//

import UIKit
import PinLayout

class VisitorChartView: UIView {

	let graphImageView = UIImageView()
	let statusImageView = UIImageView()
	let descriptionLabel = UILabel()
	let countLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}


	private func setupViews() {
		graphImageView.contentMode = .scaleAspectFit
		graphImageView.image = UIImage(named: "greenGraph") 
		addSubview(graphImageView)

		countLabel.text = "1356"
		countLabel.font = UIFont.boldSystemFont(ofSize: 22)
		countLabel.textColor = .black
		addSubview(countLabel)

	
		statusImageView.contentMode = .scaleAspectFit
		statusImageView.image = UIImage(named: "up") 
		addSubview(statusImageView)

		descriptionLabel.text = "Количество посетителей в этом месяце выросло"
		descriptionLabel.font = UIFont.systemFont(ofSize: 14)
		descriptionLabel.textColor = .gray
		descriptionLabel.numberOfLines = 0
		addSubview(descriptionLabel)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		graphImageView.pin.left(10).vCenter().width(95).height(50)
        countLabel.pin.after(of: graphImageView).marginLeft(10).top(15).sizeToFit()
		statusImageView.pin.after(of: countLabel).marginLeft(5).top(17).width(12).height(12)
		descriptionLabel.pin.below(of: countLabel).marginTop(4).left(to: countLabel.edge.left).right(20)
		descriptionLabel.sizeToFit()
	}
}
