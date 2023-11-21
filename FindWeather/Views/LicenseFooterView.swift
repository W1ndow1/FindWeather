//
//  LicenseFooterView.swift
//  FindWeather
//
//  Created by window1 on 2023/03/05.
//

import UIKit

class LicenseFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var licenseLabel: UILabel!
    
    override func prepareForReuse() {
        super.awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        licenseLabel.text = "Copyright 2023 window1 😀🍎🦉"
        licenseLabel.textColor = UIColor.white
    }
}
