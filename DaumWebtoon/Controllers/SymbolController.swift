//
//  SymbolController.swift
//  DaumWebtoon
//
//  Created by oingbong on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SymbolDatasource: class {
    func shapeRhombus() -> [UIBezierPath]
    func shapeN() -> [UIBezierPath]
}

class SymbolController: UIViewController {
    
    var symbolView: SymbolView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolView = SymbolView(frame: CGRect(origin: CGPoint(x: 87, y: 233), size: CGSize(width: 200, height: 200)))
        symbolView.backgroundColor = .green
        symbolView.dataSource = self
        self.view.addSubview(symbolView)
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
        symbolView.timeOffset(value: Double(sender.value))
    }
}

extension SymbolController: SymbolDatasource {
    public func shapeRhombus() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(0, 0, 28.2, 0, 28.2, 200, 0, 200))
        coordinates.append(coordinate(0, 200, 0, 171.8, 200, 171.8, 200, 200))
        coordinates.append(coordinate(0, 28.2, 0, 0, 200, 0, 200, 28.2))
        coordinates.append(coordinate(171.8, 0, 200, 0, 200, 200, 171.8, 200))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(20, 20, 48.2, 20, 48.2, 180, 20, 180))
        coordinates.append(coordinate(27, 38.6, 48.2, 20, 173, 161.4, 151.8, 180))
        coordinates.append(coordinate(27, 38.6, 48.2, 20, 173, 161.4, 151.8, 180))
        coordinates.append(coordinate(151.8, 20, 180, 20, 180, 180, 151.8, 180))
        
        let paths = convertPath(from: coordinates)
        return paths
    }
}
