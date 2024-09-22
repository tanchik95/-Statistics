//
//  ViewController.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 09.09.2024.
//

import UIKit
import PinLayout
import Charts
import DGCharts


final class StatsViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {

	// MARK: Private Prorert
	private var scrollView = UIScrollView()
	private let contentView = UIView()
	private let titleLabel = UILabel()
	private let visitorsTitleLabel = UILabel()
	private let visitorsCard = VisitorChartView()
	private let buttonStackView = ButtonStackView()
	private let graphCardView = GraphRedView()
	private let mostVisitsLabel = UILabel()

	private var profileTableView: UITableView!
	private var profileListDataSource: ProfileListTableDataSource!
	private var profileListDelegate: ProfileListTableDelegate!

	private let genderAgeLabel = UILabel()
	private let buttonStackVisitProfileView = ButtonStackView()
	private let pieChartView = CircleChartView()

	private let circularProgressView = PercentageView()

	private let barChartView = HorizontalBarChartView()

	private let lineChartView = LineChartView()
	private let linearGraphView = LinearGraphView()

	private let observersLabel = UILabel()
	private let visitorsUpCard = VisitorChartView()
	private let visitorsDownCard = VisitorChartView()

	private var userController: StatisticController!
	private var users: [User] = []
	private var statictic: [Statistic] = []
	private var refreshControl = UIRefreshControl()

	private var dates: [Int] = []
	private var formattedDates: [String] = []

	

	private var contentSize: CGSize {
		CGSize(width: view.frame.width, height: view.frame.height + 1500)
	}

	private var percentMan = 0.0
	private var percentWoman = 0.0
	private let ageGroups = ["18-21", "22-25", "26-30", "31-35", "36-40", "40-50", ">50"]

	private var maleCountsInAgeGroups: [Int] = []
	private var femaleCountsInAgeGroups: [Int] = []
	private var dateCountDict = [Int: Int]()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()

		let networkManager = NetworkManager()
		userController = StatisticController(networkManager: networkManager)

		setupRefreshControl()

		fetchUserData()
		fetchStatisticData()
	}

	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

		scrollView.addSubview(refreshControl)
	}

	private func setupScrollView() {
		scrollView = UIScrollView(frame: view.bounds)
		scrollView.delegate = self
		scrollView.backgroundColor = .white
		scrollView.contentSize = CGSize(width: view.frame.width, height: contentSize.height)
		view.addSubview(scrollView)
	}

	@objc private func refreshData() {
		fetchUserData()
		fetchStatisticData()
	}

	private func fetchUserData() {
		userController.fetchUsers { [weak self] result in
			switch result {
			case .success(let users):
				self?.users = users
				self?.resetCounts()

				DispatchQueue.main.async {
					self?.processUserStatistics()
				}
			case .failure(let error):
				print("Error fetching users: \(error)")
			}
		}
	}

	private func fetchStatisticData() {
		userController.fetchStatistic { [weak self] result in
			switch result {
			case .success(let statistic):
				self?.statictic = statistic
				self?.dates = statistic.flatMap { $0.dates }
				self?.setDataChart(dates: self?.dates ?? [])
				let subscriptionsCount = statistic.filter { $0.type == "subscription" }.count
				let unsubscriptionsCount = statistic.filter { $0.type == "unsubscription" }.count
				DispatchQueue.main.async {
					self?.setObservers(subscription: "\(subscriptionsCount)", unsubscription: "\(unsubscriptionsCount)")
					self?.refreshControl.endRefreshing()
				}
			case .failure(let error):
				print("Error fetching statistics: \(error)")
				DispatchQueue.main.async {
					self?.refreshControl.endRefreshing()
				}
			}
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if refreshControl.isRefreshing {
			scrollView.contentInset.top = refreshControl.frame.height
		} else {
			scrollView.contentInset.top = 0
		}
	}

	private func updateDataSource(with users: [User]) {
		self.profileListDataSource = ProfileListTableDataSource(data: users)
		profileListDelegate = ProfileListTableDelegate()
		DispatchQueue.main.async { [weak self] in
			self?.profileTableView.dataSource = self?.profileListDataSource
			self?.profileTableView.reloadData()
		}
	}

	private func resetCounts() {
		maleCountsInAgeGroups = [Int](repeating: 0, count: ageGroups.count)
		femaleCountsInAgeGroups = [Int](repeating: 0, count: ageGroups.count)
	}

	private func distributeUsers(users: [User], totalMaleCount: inout Int, totalFemaleCount: inout Int) {
		for user in users {
			let age = user.age
			let sex = user.sex


			if sex == "M" {
				totalMaleCount += 1
			} else {
				totalFemaleCount += 1
			}

			switch age {
			case 18...21:
				sex == "M" ? (maleCountsInAgeGroups[0] += 1) : (femaleCountsInAgeGroups[0] += 1)
			case 22...25:
				sex == "M" ? (maleCountsInAgeGroups[1] += 1) : (femaleCountsInAgeGroups[1] += 1)
			case 26...30:
				sex == "M" ? (maleCountsInAgeGroups[2] += 1) : (femaleCountsInAgeGroups[2] += 1)
			case 31...35:
				sex == "M" ? (maleCountsInAgeGroups[3] += 1) : (femaleCountsInAgeGroups[3] += 1)
			case 36...40:
				sex == "M" ? (maleCountsInAgeGroups[4] += 1) : (femaleCountsInAgeGroups[4] += 1)
			case 41...50:
				sex == "M" ? (maleCountsInAgeGroups[5] += 1) : (femaleCountsInAgeGroups[5] += 1)
			case 51...:
				sex == "M" ? (maleCountsInAgeGroups[6] += 1) : (femaleCountsInAgeGroups[6] += 1)
			default:
				break
			}
		}
	}

	private func calculatePercentages() -> ([CGFloat], [CGFloat]) {
		var orangePercentages: [CGFloat] = []
		var redPercentages: [CGFloat] = []

		for index in 0..<ageGroups.count {
			let totalCountInGroup = maleCountsInAgeGroups[index] + femaleCountsInAgeGroups[index]

			let malePercentage = (totalCountInGroup > 0) ? (CGFloat(maleCountsInAgeGroups[index]) / CGFloat(totalCountInGroup) * 100) : 0
			let femalePercentage = (totalCountInGroup > 0) ? (CGFloat(femaleCountsInAgeGroups[index]) / CGFloat(totalCountInGroup) * 100) : 0

			redPercentages.append(malePercentage)
			orangePercentages.append(femalePercentage)
		}

		return (orangePercentages, redPercentages)
	}

	private func calculatePieChartPercentages(totalMaleCount: Int, totalFemaleCount: Int) -> (Double, Double) {
		let totalCount = totalMaleCount + totalFemaleCount
		let manPercentage = (totalCount > 0) ? (Double(totalMaleCount) / Double(totalCount) * 100) : 0
		let womanPercentage = (totalCount > 0) ? (Double(totalFemaleCount) / Double(totalCount) * 100) : 0
		return (manPercentage, womanPercentage)
	}

	private func updateUI(with users: [User], orangePercentages: [CGFloat], redPercentages: [CGFloat], manPercentage: Double, womanPercentage: Double) {
		self.updateDataSource(with: users)
		profileListDataSource?.updateData(with: users)
		profileTableView.dataSource = profileListDataSource
		profileTableView.reloadData()
		linearGraphView.configure(labels: ageGroups, orangePercentages: orangePercentages, redPercentages: redPercentages)
		pieChartView.setupChart(manPercentage: manPercentage, womanPercentage: womanPercentage)
	}

	private func fetchStatistic() {
		userController.fetchStatistic { [weak self] result in
			switch result {
			case .success(let statistic):
				self?.statictic = statistic
				self?.dates = statistic.flatMap { $0.dates }
				self?.setDataChart(dates: self?.dates ?? [])
				DispatchQueue.main.async {}
			case .failure(let error):
				print("Error fetching users: \(error)")
			}
		}
	}

	private func processUserStatistics() {
		var totalMaleCount = 0
		var totalFemaleCount = 0

		distributeUsers(users: users, totalMaleCount: &totalMaleCount, totalFemaleCount: &totalFemaleCount)

		let (orangePercentages, redPercentages) = calculatePercentages()
		let (manPercentage, womanPercentage) = calculatePieChartPercentages(totalMaleCount: totalMaleCount, totalFemaleCount: totalFemaleCount)
		updateUI(with: users, orangePercentages: orangePercentages, redPercentages: redPercentages, manPercentage: manPercentage, womanPercentage: womanPercentage)
	}

	private func setDataChart(dates: [Int]) {
		var dateCountDict = [Int: Int]()

		dates.forEach { date in
			dateCountDict[date, default: 0] += 1
		}

		let uniqueDates = dateCountDict.keys.sorted()
		let values = uniqueDates.map { Double(dateCountDict[$0]!) }

		let formattedNumbers = uniqueDates.map { formatNumber(Double($0) / 1_000_000) }
		let dataEntries = values.enumerated().map { ChartDataEntry(x: Double($0), y: $1) }
		let lineChartDataSet = createLineChartDataSet(entries: dataEntries)

		configureChartView(with: lineChartDataSet, formattedNumbers: formattedNumbers)
	}

	private func formatNumber(_ value: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		formatter.decimalSeparator = "."
		formatter.groupingSeparator = ","
		return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
	}

	private func setObservers(subscription: String, unsubscription: String) {
		visitorsUpCard.countLabel.text = subscription
		visitorsDownCard.countLabel.text = unsubscription
	}

	private func createLineChartDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
		let dataSet = LineChartDataSet(entries: entries, label: "")
		dataSet.colors = [NSUIColor.red]
		dataSet.drawValuesEnabled = false
		dataSet.circleColors = [NSUIColor.red]
		dataSet.drawCirclesEnabled = true
		dataSet.lineWidth = 2.0
		dataSet.circleRadius = 6.0
		return dataSet
	}

	private func configureChartView(with dataSet: LineChartDataSet, formattedNumbers: [String]) {
		lineChartView.xAxis.drawGridLinesEnabled = false
		lineChartView.leftAxis.drawGridLinesEnabled = false
		lineChartView.rightAxis.drawGridLinesEnabled = false
		lineChartView.xAxis.labelPosition = .bottom
		lineChartView.xAxis.granularity = 1
		lineChartView.leftAxis.enabled = false
		lineChartView.rightAxis.enabled = false

		let lineChartData = LineChartData(dataSet: dataSet)
		if lineChartData.dataSetCount > 0 {
			lineChartView.data = lineChartData
			lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: formattedNumbers)
			formattedDates = formattedNumbers
			lineChartView.notifyDataSetChanged()
		} else {
			print("No data for the chart")
		}
	}

	private func setupUI() {
		view.backgroundColor = .init(red: 233/255, green: 233/255, blue: 234/255, alpha: 1.0)

		setupScrollView()
		setupContentView()

		setupTitleLabel()
		setupVisitorsTitleLabel()

		setupCard(visitorsCard)
		setupButtonStackView()

		setupCard(graphCardView)

		setupMostVisitsLabel()

		setupGenderAgeLabel()
		setupButtonStackVisitProfileView()
		setupProfileTableView()

		setupLineChartView()
		setupGestureRecognizer()

		setupObserversLabel()

		setupCard(visitorsUpCard)
		setupCard(visitorsDownCard)

		setupVisitorsUpView()
		setupVisitorsDownView()

		setupSubviews()
	}

	private func setupContentView() {
		contentView.backgroundColor = .init(red: 233/255, green: 233/255, blue: 234/255, alpha: 1.0)
		contentView.frame.size = contentSize
	}

	private func setupTitleLabel() {
		titleLabel.text = "Статистика"
		titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
	}

	private func setupVisitorsTitleLabel() {
		visitorsTitleLabel.text = "Посетители"
		visitorsTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		graphCardView.tooltipView.isHidden = true
	}

	private func setupCard(_ cardView: UIView) {
		cardView.backgroundColor = .white
		cardView.layer.cornerRadius = 12
		cardView.layer.shadowColor = UIColor.black.cgColor
		cardView.layer.shadowOpacity = 0.1
		cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
	}

	private func setupButtonStackView() {
		buttonStackView.buttonTitles = ["По дням", "По неделям", "По месяцам"]
	}

	private func setupMostVisitsLabel() {
		mostVisitsLabel.text = "Чаще всех посещают Ваш профиль"
		mostVisitsLabel.font = UIFont.boldSystemFont(ofSize: 20)
	}

	private func setupProfileTableView() {
		profileTableView = UITableView()
		profileTableView.tableFooterView = UIView()
		profileTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 0))
		profileTableView.isScrollEnabled = true
		profileTableView.alwaysBounceVertical = false
		profileTableView.showsVerticalScrollIndicator = false
		profileTableView.layer.cornerRadius = 12
		profileTableView.layer.shadowColor = UIColor.black.cgColor
		profileTableView.layer.shadowOpacity = 0.1
		profileTableView.layer.shadowOffset = CGSize(width: 0, height: 2)
		profileTableView.backgroundColor = .white
		profileTableView.dataSource = profileListDataSource
		profileTableView.delegate = profileListDelegate
		profileTableView.rowHeight = UITableView.automaticDimension
		profileTableView.register(ProfileListTableCell.self, forCellReuseIdentifier: "CellIdentifier")
	}

	private func setupGenderAgeLabel() {
		genderAgeLabel.text = "Пол и возраст"
		genderAgeLabel.font = UIFont.boldSystemFont(ofSize: 20)
	}

	private func setupButtonStackVisitProfileView() {
		buttonStackVisitProfileView.buttonTitles = ["Сегодня", "Неделя", "Месяц", "Все время"]
	}

	private func setupLineChartView() {
		lineChartView.frame = CGRect(x: 20, y: 80, width: view.frame.width - 80, height: 100)
	}

	private func setupGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chartTapped(_:)))
		lineChartView.addGestureRecognizer(tapGestureRecognizer)
	}

	private func setupObserversLabel() {
		observersLabel.text = "Наблюдатели"
		observersLabel.font = UIFont.boldSystemFont(ofSize: 20)
	}

	private func setupVisitorsUpView() {
		visitorsUpCard.descriptionLabel.text = "Новые наблюдатели в этом месяце"
	}

	private func setupVisitorsDownView() {
		visitorsDownCard.descriptionLabel.text = "Пользователей перестали за Вами наблюдать"
		visitorsDownCard.graphImageView.image = UIImage(named: "redGraph")
		visitorsDownCard.statusImageView.image = UIImage(named: "down")
	}

	private func setupSubviews() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(visitorsTitleLabel)
		contentView.addSubview(visitorsCard)
		contentView.addSubview(buttonStackView)
		contentView.addSubview(graphCardView)
		graphCardView.addSubview(lineChartView)
		contentView.addSubview(mostVisitsLabel)
		contentView.addSubview(profileTableView)
		contentView.addSubview(genderAgeLabel)
		contentView.addSubview(buttonStackVisitProfileView)
		contentView.addSubview(pieChartView)
		contentView.addSubview(circularProgressView)
		contentView.addSubview(linearGraphView)
		contentView.addSubview(observersLabel)
		contentView.addSubview(visitorsUpCard)
		contentView.addSubview(visitorsDownCard)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		titleLabel.pin.marginTop(10%).horizontally(10).sizeToFit()
		visitorsTitleLabel.pin.below(of: titleLabel).marginTop(10).horizontally(10).height(50)
		visitorsCard.pin.below(of: visitorsTitleLabel).marginTop(10).horizontally(16).height(98)
		buttonStackView.pin.below(of: visitorsCard, aligned: .left).marginTop(30).horizontally(20).height(32)
		graphCardView.pin.below(of: buttonStackView).marginTop(12).horizontally(16).height(208)
		mostVisitsLabel.pin.below(of: graphCardView).marginTop(20).left(10).right(10).sizeToFit()
		profileTableView.pin.below(of: mostVisitsLabel).marginTop(20).horizontally(16).height(200)

		genderAgeLabel.pin.below(of: profileTableView).marginTop(20).left(10).right(10).sizeToFit()
		buttonStackVisitProfileView.pin.below(of: genderAgeLabel, aligned: .left).marginTop(30).horizontally(20).height(32)

		pieChartView.pin.below(of: buttonStackVisitProfileView).marginTop(30).horizontally(16).height(150)
		circularProgressView.pin.below(of: pieChartView).marginTop(33).horizontally(16)

		linearGraphView.pin.below(of: circularProgressView).marginTop(40).horizontally(16).height(200)

		observersLabel.pin.below(of: linearGraphView).marginTop(30).left(10).right(10).sizeToFit()
		visitorsUpCard.pin.below(of: observersLabel).marginTop(10).horizontally(16).height(98)
		visitorsDownCard.pin.below(of: visitorsUpCard).marginTop(2).horizontally(16).height(98)
	}

	@objc private func chartTapped(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: lineChartView)

		guard let closestEntry = lineChartView.getEntryForTouchPoint(location) else {
			return
		}

		let visitorsCount = Int(closestEntry.y)
		let index = Int(closestEntry.x)

		if index >= 0 && index < formattedDates.count {
			let formattedDate = formattedDates[index]

			graphCardView.updateTooltip(title: "\(visitorsCount) посетитель", date: formatDate(from: formattedDate) ?? "")
		} else {
			print("Out of range Index")
		}
	}

	private func formatDate(from formattedDateString: String) -> String? {
		let components = formattedDateString.split(separator: ".").compactMap { Int($0) }

		guard components.count == 2 else {
			return nil
		}

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.dateFormat = "d M"

		let dateStr = "\(components[0]) \(components[1])"

		guard let date = dateFormatter.date(from: dateStr) else {
			return nil
		}

		dateFormatter.dateFormat = "d MMMM"
		return dateFormatter.string(from: date)
	}
}
