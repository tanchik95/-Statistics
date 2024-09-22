//
//  RealmStatistic.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 22.09.2024.
//

import Foundation
import RealmSwift

class RealmStatistic: Object {
	@objc dynamic var userId: Int = 0
	@objc dynamic var type: String = ""
	var dates = List<Int>() 

	enum CodingKeys: String {
		case userId = "user_id"
		case type, dates
	}

	override static func primaryKey() -> String? {
		return "userId"
	}
}
