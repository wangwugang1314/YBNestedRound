//
//  YBView.swift
//  YBCeShi
//
//  Created by FuYun on 2016/11/19.
//  Copyright © 2016年 FuYun. All rights reserved.
//

import UIKit

class YBView: UIView {
    
    static let linePoint: CGFloat = 200
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(YBView.timerClick), userInfo: nil, repeats: true)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        for index in 0..<dataArr.count {
            let data = dataArr[index]
            if index > 0 {
                let jiaoDu: CGFloat = CGFloat(Float.pi) / 180.0 * CGFloat(data.currentJiaoDu)
                let beforeData = dataArr[index - 1]
                data.pointX = beforeData.pointX + beforeData.r * Float(cos(jiaoDu))
                data.pointY = beforeData.pointY + beforeData.r * Float(sin(jiaoDu))
                
            }
            context.addArc(center: CGPoint(x: CGFloat(data.pointX),y: CGFloat(data.pointY)),
                           radius: CGFloat(data.r),
                           startAngle: 0,
                           endAngle: CGFloat(Float.pi) * CGFloat(2),
                           clockwise: false)
            context.setFillColor(data.color.cgColor)
            context.drawPath(using: .fill)
            data.currentJiaoDu += data.jiaoDu
        }
        let lastData = dataArr.last!
        context.move(to: CGPoint(x: CGFloat(lastData.pointX), y: CGFloat(lastData.pointY)))
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.orange.cgColor)
        pointXs.removeLast()
        pointXs.insert(CGFloat(lastData.pointY), at: 0)
        
        for index in 0..<pointXs.count {
            context.addLine(to: CGPoint(x: CGFloat(400 + index * 3), y: pointXs[index]))
        }
        context.drawPath(using: .stroke)
    }
    
    @objc func timerClick(){
        setNeedsDisplay()
    }
    
    private lazy var dataArr: [YBModel] = {
        var dataArr = Array<YBModel>()
        dataArr.append(YBModel.model(r: 70, pointX: Float(linePoint), pointY: Float(linePoint), color: UIColor.red, jiaoDu: 1))
        dataArr.append(YBModel.model(r: 50, pointX: Float(linePoint), pointY: Float(linePoint), color: UIColor.green, jiaoDu: 2))
        dataArr.append(YBModel.model(r: 40, pointX: Float(linePoint), pointY: Float(linePoint), color: UIColor.blue, jiaoDu: 3))
        dataArr.append(YBModel.model(r: 30, pointX: Float(linePoint), pointY: Float(linePoint), color: UIColor.gray, jiaoDu: 4))
        dataArr.append(YBModel.model(r: 20, pointX: Float(linePoint), pointY: Float(linePoint), color: UIColor.purple, jiaoDu: 5))
        return dataArr
    }()
    
    private lazy var pointXs: [CGFloat] = {
        var pointXs = [CGFloat]()
        for _ in 0..<100 {
            pointXs.append(linePoint)
        }
        return pointXs
    }()
}

class YBModel {
    var r:Float = 0
    var pointX:Float = 0
    var pointY:Float = 0
    var color = UIColor.clear
    var jiaoDu:Float = 0
    var currentJiaoDu:Float = 0
    
    class func model(r: Float, pointX: Float, pointY: Float, color: UIColor, jiaoDu: Float) -> YBModel {
        let model = YBModel()
        model.r = r
        model.pointX = pointX
        model.pointY = pointY
        model.color = color
        model.jiaoDu = jiaoDu
        return model
    }
}
