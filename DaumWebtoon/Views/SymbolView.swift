//
//  SymbolView.swift
//  DaumWebtoon
//
//  Created by oingbong on 30/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SymbolView: UIView {
    private let animationKey = "transform.rotation"
    private var pieces = [PieceLayer]()
    var dataSource: SymbolDatasource? {
        didSet {
            guard let dataSource = self.dataSource else { return }
            configureShapes(with: dataSource)
            configureRotateAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureShapes(with dataSource: SymbolDatasource) {
        let pieceC = dataSource.shapeC()
        let pieceCtoN = dataSource.shapeCtoN()
        let pieceN = dataSource.shapeN()
        let pieceNtoHourglass = dataSource.shapeNtoHourglass()
        let pieceHourglass = dataSource.shapeHourglass()
        let pieceHourglassToIce = dataSource.shapeHourglassToIce()
        let pieceIce = dataSource.shapeIce()
        let pieceIceToC = dataSource.shapeIceToC()
        let pieceAnotherC = dataSource.shapeAnotherC()
        
        for index in 0..<pieceC.count {
            let piece = PieceLayer(color: .red, path: pieceC[index])
            piece.pathAnimation(pathCtoN: pieceCtoN[index], pathN: pieceN[index], pathNtoHourglass: pieceNtoHourglass[index], pathHourglass: pieceHourglass[index], pathHourglassToIce: pieceHourglassToIce[index], pathIce: pieceIce[index], pathIceToC: pieceIceToC[index], pathAnotherC: pieceAnotherC[index])
            piece.colorAnimation()
            // for C Shape
            if index == 6 || index == 7 {
                piece.opacityAnimation()
            }
            pieces.append(piece)
            self.layer.addSublayer(piece)
        }
    }
    
    private func configureRotateAnimation() {
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fromValue = 0
        animation.toValue = CGFloat(Double.pi * 2)
        self.layer.speed = 0
        self.layer.timeOffset = 0
        self.layer.add(animation, forKey: animationKey)
    }
    
    func timeOffset(value: Double) {
        for piece in pieces {
            piece.timeOffset = value
        }
        self.layer.timeOffset = value
    }
}
