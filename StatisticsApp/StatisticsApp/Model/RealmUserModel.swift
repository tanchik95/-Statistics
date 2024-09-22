//
//  UserRealmModel.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 22.09.2024.
//

import Foundation
import RealmSwift

class RealmUser: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var sex: String = ""
	@objc dynamic var username: String = ""
	@objc dynamic var isOnline: Bool = false
	@objc dynamic var age: Int = 0
	var files = List<RealmFile>()

	enum CodingKeys: String {
		case id, sex, username, isOnline, age, files
	}

	override static func primaryKey() -> String? {
		return "id"
	}
}

class RealmFile: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var url: String = ""
	@objc dynamic var type: String = ""

	override static func primaryKey() -> String? {
		return "id" 
	}
}
