//
//  StatisticModel.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 09.09.2024.
//

import Foundation

struct StatisticModel: Codable {
	let statistics: [Statistic]
}

struct Statistic: Codable {
	let userId: Int
	let type: String
	let dates: [Int]

	enum CodingKeys: String, CodingKey {
		case userId = "user_id"
		case type
		case dates
	}
}

