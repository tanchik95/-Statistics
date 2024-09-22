//
//  LineChartView+Extension.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 21.09.2024.
//

import Foundation
import DGCharts

extension LineChartView {
	func getEntryForTouchPoint(_ touchPoint: CGPoint) -> ChartDataEntry? {
		let highlight = getHighlightByTouchPoint(touchPoint)

		if let highlight = highlight {
			let dataSetIndex = highlight.dataSetIndex
			let entryIndex = highlight.x
			guard let dataSet = self.data?.dataSets[dataSetIndex] as? LineChartDataSet else { return nil }
			return dataSet.entryForIndex(Int(entryIndex))
		}
		return nil
	}
}
