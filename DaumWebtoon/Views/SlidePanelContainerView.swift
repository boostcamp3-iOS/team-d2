//
//  SlidePanelContainerView.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SlidePanelContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let leftRect = CGRect(x: 0, y: 0, width: (superview?.frame.size.width)! / 2, height: (superview?.frame.size.height)!)
        UIColor.white.set()
        UIRectFill(leftRect)
    }
    
}
