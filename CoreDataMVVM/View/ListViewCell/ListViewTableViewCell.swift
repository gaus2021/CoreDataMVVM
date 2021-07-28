//
//  ListViewTableViewCell.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {
    
    //MARK:- Outlet Declaration
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
