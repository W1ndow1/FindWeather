//
//  LicenseFooterView.swift
//  FindWeather
//
//  Created by ChangwonKim on 2023/03/05.
//

import UIKit

class LicenseFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var licenseLabel: UILabel!
    
    override func prepareForReuse() {
        super.awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        licenseLabel.text = "2023 😀 화이팅!!"
        licenseLabel.textColor = UIColor.systemPink
    }
}
