//
//  HeaderView.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 12/4/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var  headerLabel: UILabel!

   
    override func prepareForReuse() {
        self.headerLabel.text = nil
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
