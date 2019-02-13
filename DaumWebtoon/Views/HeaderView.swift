//
//  HeaderView.swift
//  DaumWebtoon
//
//  Created by oingbong on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private var firstView = UIView()
    private var secondView = UIView()
    private var titleLabel = UILabel()
    private var imageView = UIImageView()
    var symbolView = SymbolView(frame: CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 100, height: 100)))
    
    /*
     설정 방법 : 추가할 컨트롤러에서 아래와 같이 설정합니다.
     let headerView = HeaderView(frame: CGRect(origin: .zero, size: CGSize(width: 350, height: 350)))
     headerView.configureData(title: title, with: imageName)
     self.addSubview(headerView)
     
     추가할 컨트롤러를 심볼의 데이터소스로 지정하고 scale 과 slideSymbol 의 변수값을 더합니다.
     ex )
     Before : symbolView.frame.width
     After : heaverView.symbolView.frame.width
     Before : symbolView.frame.height
     After : heaverView.symbolView.frame.height
     Before : symbolView.dataSource = self
     After : headerView.symbolView.dataSource = self
     
     ** 심볼뷰를 뷰 안에 뷰로 추가하거나 컨트롤러에 직접 추가하더라도 이전에 없던 렉(?) 현상이 생김, 메인뷰와 합칠 때 다시 확인 필요
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        configureFirstView()
        configureSecondView()
        configureSymbolView()
    }
    
    private func configureFirstView() {
        addSubview(firstView)
        firstView.backgroundColor = .orange
        firstView.translatesAutoresizingMaskIntoConstraints = false
        firstView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        firstView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        firstView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        firstView.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func configureSecondView() {
        addSubview(secondView)
        secondView.backgroundColor = .gray
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        secondView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        secondView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func configureSymbolView() {
        firstView.addSubview(symbolView)
    }
    
    func configureData(title: String, with image: String) {
        configureTitle(with: title)
        configureImage(with: image)
    }
    
    private func configureTitle(with title: String) {
        firstView.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.frame.size = CGSize(width: 100, height: 40)
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: firstView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
    }
    
    private func configureImage(with image: String) {
        secondView.addSubview(imageView)
        imageView.image = UIImage(named: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: secondView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor).isActive = true
    }
    
    func timeOffset(value: Double) {
        symbolView.timeOffset(value: value)
    }
}
