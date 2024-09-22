//
//  UserModel.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 09.09.2024.
//

import Foundation

struct UserModel: Codable {
	let users: [User]
}

// MARK: - User
struct User: Codable {
	let id: Int
	let sex: String
	let username: String
	let isOnline: Bool
	let age: Int
	let files: [File]

	enum CodingKeys: String, CodingKey {
		case id, sex, username, isOnline, age, files
	}
}

// MARK: - File
struct File: Codable {
	let id: Int
	let url: String
	let type: String
}


