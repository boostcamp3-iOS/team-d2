//
//  SymbolController.swift
//  DaumWebtoon
//
//  Created by oingbong on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SymbolController: UIViewController {
    private var pieces = [PieceLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beforePieces = shapeRhombus()
        let afterPieces = shapeN()
        
        for index in 0..<beforePieces.count {
            let piece = PieceLayer(color: .red, path: beforePieces[index])
            piece.configureAnimation(to: afterPieces[index])
            pieces.append(piece)
            view.layer.addSublayer(piece)
        }
    }
    
    private func coordinate(_ x1: CGFloat, _ y1: CGFloat,
                            _ x2: CGFloat, _ y2: CGFloat,
                            _ x3: CGFloat, _ y3: CGFloat,
                            _ x4: CGFloat, _ y4: CGFloat) -> [CGPoint] {
        var points = [CGPoint]()
        points.append(CGPoint(x: x1, y: y1))
        points.append(CGPoint(x: x2, y: y2))
        points.append(CGPoint(x: x3, y: y3))
        points.append(CGPoint(x: x4, y: y4))
        return points
    }
    
    private func convertPath(from coordinates: [[CGPoint]]) -> [UIBezierPath] {
        let paths = coordinates.map { self.path(with: $0) }
        return paths
    }
    
    private func path(with coordinates: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: coordinates[0])
        path.addLine(to: coordinates[1])
        path.addLine(to: coordinates[2])
        path.addLine(to: coordinates[3])
        path.close()
        return path
    }
    
    @IBAction func doSlider(_ sender: UISlider) {
        for piece in pieces {
            piece.timeOffset = Double(sender.value)
        }
    }
}

// MARK: Shapes
extension SymbolController {
    // MARK: Rhombus(마름모)
    private func shapeRhombus() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(100, 0, 0, 100, 20, 120, 120, 20))
        coordinates.append(coordinate(0, 100, 100, 200, 120, 180, 20, 80))
        coordinates.append(coordinate(80, 20, 180, 120, 200, 100, 100, 0))
        coordinates.append(coordinate(180, 80, 80, 180, 100, 200, 200, 100))
        
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    // MARK: N
    private func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(20, 20, 20, 180, 48.2, 180, 48.2, 20))
        coordinates.append(coordinate(27, 38.6, 151.8, 180, 173, 161.4, 48.2, 20))
        coordinates.append(coordinate(27, 38.6, 151.8, 180, 173, 161.4, 48.2, 20))
        coordinates.append(coordinate(151.8, 20, 151.8, 180, 180, 180, 180, 20))
        
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    // MARK: C
    // MARK: Sandglass(모래시계
    // MARK: O
    // MARK: Asterisk(별모양)
}
