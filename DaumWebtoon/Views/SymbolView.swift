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
    var dataSource: SymbolDatasource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let dataSource = self.dataSource else { return }
        configureShapes(with: dataSource)
        configureRotateAnimation()
    }
    
    private func configureShapes(with dataSource: SymbolDatasource) {
        let beforePieces = dataSource.shapeN()
        let afterPieces = dataSource.shapeRhombus()
        
        for index in 0..<beforePieces.count {
            let piece = PieceLayer(color: .red, path: beforePieces[index])
            piece.configureAnimation(to: afterPieces[index])
            pieces.append(piece)
            self.layer.addSublayer(piece)
        }
    }
    
    private func configureRotateAnimation() {
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = CGFloat(-Double.pi / 4)
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
