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
    func shapeC() -> [UIBezierPath]
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
        coordinates.append(coordinate(x1: 0, y1: 0, x2: 0, y2: 100, x3: 40, y3: 100, x4: 40, y4: 0))
        coordinates.append(coordinate(x1: 0, y1: 100, x2: 0, y2: 200, x3: 40, y3: 200, x4: 40, y4: 100))
        coordinates.append(coordinate(x1: 0, y1: 40, x2: 200, y2: 40, x3: 200, y3: 0, x4: 0, y4: 0))
        coordinates.append(coordinate(x1: 0, y1: 200, x2: 200, y2: 200, x3: 200, y3: 160, x4: 0, y4: 160))
        coordinates.append(coordinate(x1: 160, y1: 0, x2: 160, y2: 100, x3: 200, y3: 100, x4: 200, y4: 0))
        coordinates.append(coordinate(x1: 160, y1: 100, x2: 160, y2: 200, x3: 200, y3: 200, x4: 200, y4: 100))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(x1: 0, y1: 0, x2: 0, y2: 100, x3: 40, y3: 100, x4: 40, y4: 0))
        coordinates.append(coordinate(x1: 0, y1: 100, x2: 0, y2: 200, x3: 40, y3: 200, x4: 40, y4: 100))
        coordinates.append(coordinate(x1: 9.8, y1: 26, x2: 160, y2: 200, x3: 190.2, y3: 173.8, x4: 40, y4: 0))
        coordinates.append(coordinate(x1: 9.8, y1: 26, x2: 160, y2: 200, x3: 190.2, y3: 173.8, x4: 40, y4: 0))
        coordinates.append(coordinate(x1: 160, y1: 0, x2: 160, y2: 100, x3: 200, y3: 100, x4: 200, y4: 0))
        coordinates.append(coordinate(x1: 160, y1: 100, x2: 160, y2: 200, x3: 200, y3: 200, x4: 200, y4: 100))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeC() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        coordinates.append(coordinate(x1: 50, y1: 13.4, x2: 0, y2: 100, x3: 46.2, y3: 100, x4: 73.2, y4: 53.4))
        coordinates.append(coordinate(x1: 0, y1: 100, x2: 50, y2: 186.6, x3: 73, y3: 146.6, x4: 46.2, y4: 100))
        coordinates.append(coordinate(x1: 73.2, y1: 53.4, x2: 127, y2: 53.4, x3: 150, y3: 13.4, x4: 50, y4: 13.4))
        coordinates.append(coordinate(x1: 50, y1: 186.6, x2: 150, y2: 186.6, x3: 126.8, y3: 146.6, x4: 73, y4: 146.6))
        coordinates.append(coordinate(x1: 127, y1: 53.4, x2: 153.8, y2: 100, x3: 200, y3: 100, x4: 150, y4: 13.4))
        coordinates.append(coordinate(x1: 153.8, y1: 100, x2: 126.8, y2: 146.6, x3: 150, y3: 186.6, x4: 200, y4: 100))
        let paths = convertPath(from: coordinates)
        return paths
    }
}
