//
//  Chart.swift
//  colorie-counter
//
//
//

import UIKit
import Charts

class Chart: UIView, ChartViewDelegate {

    var  pieChart = PieChartView()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.frame.size.width,
                                height: self.frame.size.width)
        
        
    }
    

}
