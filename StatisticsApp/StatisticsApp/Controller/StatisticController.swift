//
//  StatisticController.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 13.09.2024.
//

import Foundation
import Realm
import RxSwift
import RealmSwift

final class StatisticController {
	private let realm = try! Realm()
	private let networkManager: NetworkManager
	private let disposeBag = DisposeBag()

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}

	func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
		let savedUsers = realm.objects(RealmUser.self)

		if savedUsers.isEmpty {
			networkManager.fetchUsers()
				.subscribe(onNext: { [weak self] userModel in
					guard let self = self else { return }
					let users = userModel.users
					DispatchQueue.main.async {
						self.saveUsersToRealm(users: users)
						completion(.success(users))
					}
				}, onError: { error in
					DispatchQueue.main.async {
						completion(.failure(error))
					}
				})
				.disposed(by: disposeBag)
		} else {
			completion(.success(convertRealmUsersToUsers(Array(savedUsers))))
		}
	}

	func fetchStatistic(completion: @escaping (Result<[Statistic], Error>) -> Void) {
		let savedStatistics = realm.objects(RealmStatistic.self)

		if savedStatistics.isEmpty {
			networkManager.fetchStatistic()
				.subscribe(onNext: { [weak self] statisticModel in
					guard let self = self else { return }
					let statistics = statisticModel.statistics
					DispatchQueue.main.async {
						self.saveStatisticsToRealm(statistics: statistics) // Ensure this runs on the right thread
						completion(.success(statistics))
					}
				}, onError: { error in
					DispatchQueue.main.async {
						completion(.failure(error))
					}
				})
				.disposed(by: disposeBag)
		} else {
			completion(.success(convertRealmStatisticsToStatistics(Array(savedStatistics))))
		}
	}

	private func saveUsersToRealm(users: [User]) {
		let realmUsers = convertUsersToRealm(users)
		do {
			try realm.write {
				realm.add(realmUsers, update: .modified)
			}
		} catch {
			print("Error saving users to Realm: \(error)")
		}
	}

	private func saveStatisticsToRealm(statistics: [Statistic]) {
		let realmStatistics = convertStatisticsToRealm(statistics)
		do {
			try realm.write {
				realm.add(realmStatistics, update: .modified)
			}
		} catch {
			print("Error saving statistics to Realm: \(error)")
		}
	}

	private func convertUsersToRealm(_ users: [User]) -> [RealmUser] {
		return users.map { user in
			let realmUser = RealmUser()
			realmUser.id = user.id
			realmUser.sex = user.sex
			realmUser.username = user.username
			realmUser.isOnline = user.isOnline
			realmUser.age = user.age
			realmUser.files.append(objectsIn: convertFilesToRealm(user.files))
			return realmUser
		}
	}

	private func convertFilesToRealm(_ files: [File]) -> [RealmFile] {
		return files.map { file in
			let realmFile = RealmFile()
			realmFile.id = file.id
			realmFile.url = file.url
			realmFile.type = file.type
			return realmFile
		}
	}

	private func convertStatisticsToRealm(_ statistics: [Statistic]) -> [RealmStatistic] {
		return statistics.map { statistic in
			let realmStatistic = RealmStatistic()
			realmStatistic.userId = statistic.userId
			realmStatistic.type = statistic.type
			realmStatistic.dates.append(objectsIn: statistic.dates)
			return realmStatistic
		}
	}

	private func convertRealmUsersToUsers(_ realmUsers: [RealmUser]) -> [User] {
		return realmUsers.map { realmUser in
			return User(
				id: realmUser.id,
				sex: realmUser.sex,
				username: realmUser.username,
				isOnline: realmUser.isOnline,
				age: realmUser.age,
				files: Array(realmUser.files.map { File(id: $0.id, url: $0.url, type: $0.type) })
			)
		}
	}

	private func convertRealmStatisticsToStatistics(_ realmStatistics: [RealmStatistic]) -> [Statistic] {
		return realmStatistics.map { realmStatistic in
			return Statistic(
				userId: realmStatistic.userId,
				type: realmStatistic.type,
				dates: Array(realmStatistic.dates) // Убедитесь, что это возвращает правильный тип
			)
		}
	}
}
