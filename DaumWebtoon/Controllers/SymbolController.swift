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
    
    private func coordinate(x1: CGFloat, y1: CGFloat,
                            x2: CGFloat, y2: CGFloat,
                            x3: CGFloat, y3: CGFloat,
                            x4: CGFloat, y4: CGFloat) -> [CGPoint] {
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
        coordinates.append(coordinate(x1: 0, y1: 0, x2: 28.2, y2: 0, x3: 28.2, y3: 200, x4: 0, y4: 200))
        coordinates.append(coordinate(x1: 0, y1: 200, x2: 0, y2: 171.8, x3: 200, y3: 171.8, x4: 200, y4: 200))
        coordinates.append(coordinate(x1: 0, y1: 28.2, x2: 0, y2: 0, x3: 200, y3: 0, x4: 200, y4: 28.2))
        coordinates.append(coordinate(x1: 171.8, y1: 0, x2: 200, y2: 0, x3: 200, y3: 200, x4: 171.8, y4: 200))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(x1: 20, y1: 20, x2: 48.2, y2: 20, x3: 48.2, y3: 180, x4: 20, y4: 180))
        coordinates.append(coordinate(x1: 27, y1: 38.6, x2: 48.2, y2: 20, x3: 173, y3: 161.4, x4: 151.8, y4: 180))
        coordinates.append(coordinate(x1: 27, y1: 38.6, x2: 48.2, y2: 20, x3: 173, y3: 161.4, x4: 151.8, y4: 180))
        coordinates.append(coordinate(x1: 151.8, y1: 20, x2: 180, y2: 20, x3: 180, y3: 180, x4: 151.8, y4: 180))
        let paths = convertPath(from: coordinates)
        return paths
    }
}
