//
//  TabBarViewController+Symbol.swift
//  DaumWebtoon
//
//  Created by oingbong on 11/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SymbolDatasource: class {
    func shapeC() -> [UIBezierPath]
    func shapeCtoN() -> [UIBezierPath]
    func shapeN() -> [UIBezierPath]
    func shapeNtoHourglass() -> [UIBezierPath]
    func shapeHourglass() -> [UIBezierPath]
    func shapeHourglassToIce() -> [UIBezierPath]
    func shapeIce() -> [UIBezierPath]
    func shapeIceToC() -> [UIBezierPath]
    func shapeAnotherC() -> [UIBezierPath]
}

// MARK: - Symbol Coordinate Method
extension MainViewController {
    private func convertKeys(from keys: String, with shape: Shape.Type) -> [(CGFloat, CGFloat)] {
        var coordinates = [(CGFloat, CGFloat)]()
        for key in keys {
            if shape is ShapeC.Type {
                guard let shapeC = ShapeC(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeC)
                coordinates.append(fixedShape)
            } else if shape is ShapeN.Type {
                guard let shapeN = ShapeN(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeN)
                coordinates.append(fixedShape)
            } else if shape is ShapeHourglass.Type {
                guard let shapeHourglass = ShapeHourglass(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeHourglass)
                coordinates.append(fixedShape)
            } else if shape is ShapeIce.Type {
                guard let shapeIce = ShapeIce(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeIce)
                coordinates.append(fixedShape)
            } else if shape is ShapeSquare.Type {
                guard let shapeSquare = ShapeSquare(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeSquare)
                coordinates.append(fixedShape)
            }
        }
        return coordinates
    }
    
    // 심볼뷰 크기에 따라 좌표값을 조절합니다.
    private func scale(with shape: Shape) -> (CGFloat, CGFloat) {
        let x = shape.coordinate.0 * headerView.symbolView.frame.width
        let y = shape.coordinate.1 * headerView.symbolView.frame.height
        return (x, y)
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
    
    func slideSymbol(with value: CGFloat) {
        let forMaxValueOne = CGFloat(4)
        headerView.timeOffset(value: Double(value / forMaxValueOne))
    }
}

// MARK: - Symbol Coordinate By Shape
extension MainViewController: SymbolDatasource {
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
    
    public func shapeIce() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "odcp", with: ShapeIce.self)
        let keys2 = convertKeys(from: "aopb", with: ShapeIce.self)
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
    
    public func shapeIceToC() -> [UIBezierPath] {
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
    
    // 좌표값이 초기 C와 동일하기 때문에 무한스크롤 할 때는 삭제하고 초기 C를 사용하면 됩니다.
    public func shapeAnotherC() -> [UIBezierPath] {
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
}
