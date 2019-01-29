//
//  SeriesViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabLabel = UILabel()
        tabLabel.frame = CGRect(x: 100, y: 300, width: 200, height: 40)
        tabLabel.textAlignment = .center
        tabLabel.textColor = UIColor.black
        tabLabel.numberOfLines = 0
        tabLabel.adjustsFontSizeToFitWidth = true
        tabLabel.font = UIFont.systemFont(ofSize: 14)
        tabLabel.alpha = 0.6
        tabLabel.text = "연재"
        
        self.view.addSubview(tabLabel)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
