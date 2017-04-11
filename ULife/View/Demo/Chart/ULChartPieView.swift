//
//  ULChartPieView.swift
//  ULife
//
//  Created by codeLocker on 2017/4/7.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULChartPieView: ULDemoBaseView {
    
    fileprivate let pieConfig = ULPieChartConfig()
    
    fileprivate lazy var pieChart : ULPieChart = {
        
        let model1 = ULPieChartModel()
        model1.title = "apple"
        model1.color = .red
        model1.count = 10
        model1.percent = 0.3
        
        let model2 = ULPieChartModel()
        model2.title = "pen"
        model2.color = .blue
        model2.count = 10
        model2.percent = 0.4
        
        let model3 = ULPieChartModel()
        model3.title = "start"
        model3.color = .yellow
        model3.count = 10
        model3.percent = 0.1
        
        let model4 = ULPieChartModel()
        model4.title = "computer"
        model4.color = .green
        model4.count = 10
        model4.percent = 0.2
        
        let pie = ULPieChart.init(frame: CGRect.zero, config: self.pieConfig, models: [model1,model2,model3,model4])
        return pie
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UIButton_Actions
    override func startBtn_Pressed(_ sender: UIButton) {
        
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.addSubview(self.pieChart)
    }
    
    private func layout() {
        self.pieChart.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
}
