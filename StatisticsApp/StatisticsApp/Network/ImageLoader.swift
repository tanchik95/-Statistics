//
//  ImageLoader.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 13.09.2024.
//

import UIKit
final class ImageLoader {
	static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
		guard let url = URL(string: urlString) else {
			completion(nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print("Error loading image: \(error)")
				completion(nil)
				return
			}

			guard let data = data else {
				completion(nil)
				return
			}

			let image = UIImage(data: data)
			completion(image)
		}

		task.resume()
	}
}
