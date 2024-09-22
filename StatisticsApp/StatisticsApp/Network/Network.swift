//
//  Network.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 09.09.2024.
//

import Foundation
import RxSwift

final class NetworkManager {
	func fetchUsers() -> Observable<UserModel> {
		guard let url = URL(string: "https://cars.cprogroup.ru/api/episode/users/") else {
			return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
		}

		return Observable.create { observer in
			let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let error = error {
					observer.onError(error)
					return
				}

				guard let data = data else {
					observer.onError(NSError(domain: "No data", code: -1, userInfo: nil))
					return
				}

				do {
					let userModel = try JSONDecoder().decode(UserModel.self, from: data)
					observer.onNext(userModel)
					observer.onCompleted()
				} catch {
					observer.onError(error)
				}
			}
			task.resume()

			return Disposables.create {
				task.cancel()
			}
		}
	}

	func fetchStatistic() -> Observable<StatisticModel> {
		guard let url = URL(string: "https://cars.cprogroup.ru/api/episode/statistics/") else {
			return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
		}

		return Observable.create { observer in
			let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let error = error {
					observer.onError(error)
					return
				}

				guard let data = data else {
					observer.onError(NSError(domain: "No data", code: -1, userInfo: nil))
					return
				}

				do {
					let userModel = try JSONDecoder().decode(StatisticModel.self, from: data)
					observer.onNext(userModel)
					observer.onCompleted()
				} catch {
					observer.onError(error)
				}
			}
			task.resume()

			return Disposables.create {
				task.cancel()
			}
		}

	}
}


