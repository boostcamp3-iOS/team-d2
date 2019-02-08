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
        let beforePieces = dataSource.shapeC()
        let passPieces = dataSource.shapeRhombus()
        let afterPieces = dataSource.shapeN()
        
        for index in 0..<beforePieces.count {
            let piece = PieceLayer(color: .red, path: beforePieces[index])
            piece.pathAnimation(passPath: passPieces[index], toPath: afterPieces[index])
            piece.colorAnimation()
            pieces.append(piece)
//            if index == 3 {
//                piece.opacityAnimation()
//            }
            self.layer.addSublayer(piece)
        }
    }
    
    private func configureRotateAnimation() {
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = CGFloat(Double.pi / 2)
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
