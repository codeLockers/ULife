//
//  ULPieChart.swift
//  ULife
//
//  Created by codeLocker on 2017/4/7.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULPieChartConfig: NSObject {
    var radius : CGFloat = 80
    var lineWidth : CGFloat = 40
    var duration : TimeInterval = 0.5
    var contentViewRadius : CGFloat = 70
    var contentViewItemMargin : CGFloat = 5
    
}

class ULPieChartModel: NSObject {
    var title : String = "title"
    var color : UIColor = .red
    var count : CGFloat = 0.0
    var percent : CGFloat = 0.0
    var startPercent : CGFloat = 0.0
}

class ULPieChart: UIView {

    fileprivate var config : ULPieChartConfig?
    fileprivate var models : [ULPieChartModel]?
    fileprivate var perLayers = [CAShapeLayer]()
    fileprivate let contentView = UIView()
    fileprivate let tapGesture = UITapGestureRecognizer()
    
    fileprivate var currectSelectedPerLayer : CAShapeLayer?
    fileprivate var contentlabels = Array<UILabel>()
    
    fileprivate var currentGesturePoint : CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, config: ULPieChartConfig?, models: [ULPieChartModel]?) {
        self.init(frame: frame)
        guard let _  = config, let _ = models else {
            return
        }
        self.config = config
        self.models = models
        loadData()
        loadUI()
        self.loadGesture()
    }
    
    //MARK: - Load_Data
    private func loadData() {
    
        var startPercent : CGFloat = 0.0
        for model in self.models! {
            model.startPercent = startPercent
            startPercent += model.percent
        }
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.backgroundColor = UIColor.white
        self.loadContentView()
        self.loadPerLabel()
    }
    
    private func loadContentView() {
        self.contentView.frame = CGRect.init(x: 0, y: 0, width: self.config!.contentViewRadius*2.0, height: self.config!.contentViewRadius*2.0);
        self.contentView.backgroundColor = UIColor.ul_rgb(r: 255, g: 255, b: 255, a: 1)
        self.contentView.layer.cornerRadius = self.config!.contentViewRadius
        self.contentView.layer.masksToBounds = true
        self.addSubview(contentView)
       
        if self.models!.count == 0 {
            return
        }
        
        let detailView = UIView()
        contentView.addSubview(detailView)
        
        var perLab : UILabel?
        for model in self.models! {
            let label = UILabel()
            label.text = "\(model.title):\(model.count)"
            label.textColor = model.color
            label.font = UIFont.systemFont(ofSize: 15)
            detailView.addSubview(label)
            
            let index = self.models!.index(of: model)
            if index == 0 {
                label.snp.makeConstraints({ (make) in
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview()
                })
            }
            if index! > 0 && perLab != nil{
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(perLab!.snp.bottom)
                    make.centerX.equalToSuperview()
                })
            }
            perLab = label
        }
        detailView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.bottom.equalTo(perLab!.snp.bottom)
        }
    }
    
    override func layoutSubviews() {
        self.drawPie()
        self.contentView.center = CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0)
        _ = self.contentlabels.map { (label) in
            let index = self.contentlabels.index(of: label)
            let center = self.calculateLabelFrame(self.models?[index!])
            if center != nil {
                label.frame = CGRect.init(x: 0, y: 0, width: 70, height: 25)
                label.center = center!
            }
        }
    }
}

extension ULPieChart {
    fileprivate func loadPerLabel() {
        for model in self.models! {
            let label = UILabel()
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 8)
            label.text = "\(model.percent * 100)%\n\(model.title)"
            label.textAlignment = .center
            self.addSubview(label)
            self.contentlabels.append(label)
        }
    }
    
    fileprivate func calculateLabelFrame(_ model:ULPieChartModel?) -> CGPoint? {
        guard let model = model else {
            return nil
        }
        let labelPercent = model.startPercent + (model.percent) / 2.0
        let angle = labelPercent * (.pi * 2)
        let radius = self.config!.contentViewRadius + (self.config!.radius + self.config!.lineWidth / 2.0 - self.config!.contentViewRadius) / 2.0
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        if labelPercent > 0 && labelPercent <= 0.25 {
            //第一象限
            x = radius * sin(angle) + self.ul_width / 2.0
            y = self.ul_height / 2.0 - radius * cos(angle)
        } else if labelPercent > 0.25 && labelPercent <= 0.5 {
            //第二象限
            x = radius * cos(angle - .pi / 2) + self.ul_width / 2.0
            y = self.ul_height / 2.0 + radius * sin(angle - .pi / 2)
        } else if labelPercent > 0.5 && labelPercent <= 0.75 {
            //第三象限
            x = self.ul_width / 2.0 - radius * sin(angle - .pi)
            y = self.ul_height / 2.0 + radius * cos(angle - .pi)
        } else if labelPercent > 0.75 && labelPercent <= 1 {
            //第四象限
            x = self.ul_width / 2.0 - radius * cos(angle - .pi / 2 * 3)
            y = self.ul_height / 2.0 - radius * sin(angle - .pi / 2 * 3)
        }
        return CGPoint.init(x: x, y: y)
    }
}

extension ULPieChart {
    
    fileprivate func drawPie() {
        
        guard let config  = self.config, let models = self.models else {
            return
        }
        let pieLayer = CAShapeLayer()
        for model in models {
            let perLayer = self.drawPerLayer(radius: config.radius, lineWidth: config.lineWidth, center: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0), strokeColor: model.color, start: model.startPercent, end: model.startPercent + model.percent)
            pieLayer.addSublayer(perLayer)
            self.perLayers.append(perLayer)
        }
        
        let lineWidth = config.radius + config.lineWidth / 2.0
        let maskLayer = self.drawPerLayer(radius: config.radius, lineWidth: lineWidth, center: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0), strokeColor: .white, start: 0, end: 1)
        pieLayer.mask = maskLayer
        
        self.layer.insertSublayer(pieLayer, at: 0)
        
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = config.duration
        pieLayer.mask?.add(animation, forKey: "strokeEnd")
    }
    
    fileprivate func drawPerLayer(radius:CGFloat, lineWidth:CGFloat, center:CGPoint, strokeColor:UIColor, start:CGFloat, end:CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: -.pi / 2.0, endAngle: 3 * .pi / 2.0, clockwise: true)
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = start
        layer.strokeEnd = end
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        return layer
    }
}

extension ULPieChart {
    fileprivate func loadGesture() {
        self.tapGesture.addTarget(self, action: #selector(tapGesture_Method(_:)))
        self.addGestureRecognizer(self.tapGesture)
    }
    
    @objc fileprivate func tapGesture_Method(_ tap:UITapGestureRecognizer) {
        let point = tap.location(in: self)
        guard let distance = point.ul_distance(to: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0)) else {
            return
        }
        if distance > self.config!.radius + self.config!.lineWidth / 2.0 {
            //点击范围不在pie上
            return
        }
        let innerRadius = max(self.config!.contentViewRadius, (self.config!.radius - self.config!.lineWidth / 2.0))
        if distance < innerRadius {
            //点击范围不在pie上
            return
        }
        
        let angle = point.ul_angle(between: CGPoint.init(x: self.ul_width/2.0, y: 0), peak: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0))
        self.calculateRange(angle)
    }
    
    fileprivate func calculateRange(_ angle : Float?) {
        guard let angle = angle else {
            return
        }
        let tapModels = self.models?.filter({ (model) -> Bool in
            let per = CGFloat(angle / (.pi * 2))
            if per > model.startPercent && per < model.startPercent + model.percent {
                return true
            }
            return false
        })
        
        guard let selectModel = tapModels?.first else {
            return
        }
        
        let index = self.models?.index(of: selectModel)
        let selectedPerLayer = self.perLayers[index!]
        if selectedPerLayer == self.currectSelectedPerLayer {
            //变回原样
            self.disSelectPerLayer(selectedPerLayer,model: selectModel)
            self.currectSelectedPerLayer = nil
        }else {
            //放大
            guard let currectSelectedPerLayer = self.currectSelectedPerLayer else {
                self.selectPerLayer(selectedPerLayer, model: selectModel)
                self.currectSelectedPerLayer = selectedPerLayer
                return
            }
            let currentSelectIndex = self.perLayers.index(of: currectSelectedPerLayer)
            self.disSelectPerLayer(currectSelectedPerLayer, model: self.models![currentSelectIndex!])
            self.selectPerLayer(selectedPerLayer, model: selectModel)
            self.currectSelectedPerLayer = selectedPerLayer
        }
    }
    
    fileprivate func selectPerLayer(_ layer:CAShapeLayer?, model:ULPieChartModel?) {
        guard let layer = layer, let model = model else {
            return
        }
        let lineWidth : CGFloat = 45.0
        let radius = (lineWidth - self.config!.lineWidth) / 2.0 + self.config!.radius
        
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0), radius: radius, startAngle: -.pi / 2.0, endAngle: 3 * .pi / 2.0, clockwise: true)
        layer.strokeColor = model.color.cgColor
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        layer.strokeStart = model.startPercent
        layer.strokeEnd = model.startPercent + model.percent
    }
    
    fileprivate func disSelectPerLayer(_ layer:CAShapeLayer?, model:ULPieChartModel?) {
        guard let layer = layer, let model = model else {
            return
        }
        let lineWidth : CGFloat = self.config!.lineWidth
        let radius = (lineWidth - self.config!.lineWidth) / 2.0 + self.config!.radius
        
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: self.ul_width/2.0, y: self.ul_height/2.0), radius: radius, startAngle: -.pi / 2.0, endAngle: 3 * .pi / 2.0, clockwise: true)
        layer.strokeColor = model.color.cgColor
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        layer.strokeStart = model.startPercent
        layer.strokeEnd = model.startPercent + model.percent
    }
}
