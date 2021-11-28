//
//  CustomFormatter.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-27.
//

import Foundation
import Charts

/*--------------------------------------------------------------------
 //MARK: CustomFormatter class
 - Description: Custom Chart Formatter that overrides the existing x axis data formatter
 -------------------------------------------------------------------*/
final class CustomFormatter: IAxisValueFormatter {
    var labels: [String] = []
    
    /*--------------------------------------------------------------------
     //MARK: stringForValue(value: Double, axis: AxisBase
     - Description: -
     -------------------------------------------------------------------*/
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        guard let axis = axis, count > 0 else {
            return ""
        }
        let factor = axis.axisMaximum / Double(count)
        let index = Int((value / factor).rounded())
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}
