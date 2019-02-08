//
//  SymbolController.swift
//  DaumWebtoon
//
//  Created by oingbong on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SymbolDatasource: class {
    func shapeCtoN() -> [UIBezierPath]
    func shapeN() -> [UIBezierPath]
    func shapeC() -> [UIBezierPath]
    func shapeNtoHourglass() -> [UIBezierPath]
    func shapeHourglass() -> [UIBezierPath]
    func shapeHourglassToIce() -> [UIBezierPath]
    func shapeIce() -> [UIBezierPath]
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
    
    private func convertKeys(from keys: String, with shape: Shape.Type) -> [(CGFloat, CGFloat)] {
        var coordinates = [(CGFloat, CGFloat)]()
        for key in keys {
            if shape is ShapeC.Type {
                guard let shape = ShapeC(rawValue: String(key)) else { break }
                coordinates.append(shape.coordinate)
            } else if shape is ShapeN.Type {
                guard let shape = ShapeN(rawValue: String(key)) else { break }
                coordinates.append(shape.coordinate)
            } else if shape is ShapeHourglass.Type {
                guard let shape = ShapeHourglass(rawValue: String(key)) else { break }
                coordinates.append(shape.coordinate)
            } else if shape is ShapeIce.Type {
                guard let shape = ShapeIce(rawValue: String(key)) else { break }
                coordinates.append(shape.coordinate)
            } else if shape is ShapeSquare.Type {
                guard let shape = ShapeSquare(rawValue: String(key)) else { break }
                coordinates.append(shape.coordinate)
            }
        }
        return coordinates
    }

    private func coordinate(xys: [(CGFloat, CGFloat)]) -> [CGPoint] {
        var points = [CGPoint]()
        for xy in xys {
            let x = xy.0
            let y = xy.1
            points.append(CGPoint(x: x, y: y))
        }
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
    public func shapeC() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "aegh", with: ShapeC.self)
        let keys2 = convertKeys(from: "cahi", with: ShapeC.self)
        let keys3 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys4 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys5 = convertKeys(from: "jkbf", with: ShapeC.self)
        let keys6 = convertKeys(from: "kldb", with: ShapeC.self)
        let keys7 = convertKeys(from: "gedl", with: ShapeC.self)
        let keys8 = convertKeys(from: "gedl", with: ShapeC.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeCtoN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "mdcn", with: ShapeN.self)
        let keys2 = convertKeys(from: "amnb", with: ShapeN.self)
        let keys3 = convertKeys(from: "iclk", with: ShapeN.self)
        let keys4 = convertKeys(from: "klje", with: ShapeN.self)
        let keys5 = convertKeys(from: "eopf", with: ShapeN.self)
        let keys6 = convertKeys(from: "ohgp", with: ShapeN.self)
        let keys7 = convertKeys(from: "klje", with: ShapeN.self)
        let keys8 = convertKeys(from: "iclk", with: ShapeN.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeNtoHourglass() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeHourglass() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "abji", with: ShapeHourglass.self)
        let keys2 = convertKeys(from: "abji", with: ShapeHourglass.self)
        let keys3 = convertKeys(from: "aenm", with: ShapeHourglass.self)
        let keys4 = convertKeys(from: "mngc", with: ShapeHourglass.self)
        let keys5 = convertKeys(from: "kldc", with: ShapeHourglass.self)
        let keys6 = convertKeys(from: "kldc", with: ShapeHourglass.self)
        let keys7 = convertKeys(from: "mndf", with: ShapeHourglass.self)
        let keys8 = convertKeys(from: "hbnm", with: ShapeHourglass.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeHourglassToIce() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeIce() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "aopb", with: ShapeIce.self)
        let keys2 = convertKeys(from: "odcp", with: ShapeIce.self)
        let keys3 = convertKeys(from: "efnm", with: ShapeIce.self)
        let keys4 = convertKeys(from: "mnhg", with: ShapeIce.self)
        let keys5 = convertKeys(from: "aopb", with: ShapeIce.self)
        let keys6 = convertKeys(from: "odcp", with: ShapeIce.self)
        let keys7 = convertKeys(from: "mnji", with: ShapeIce.self)
        let keys8 = convertKeys(from: "lknm", with: ShapeIce.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
}
