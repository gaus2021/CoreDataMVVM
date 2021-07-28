//
//  ListHeaderView.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import UIKit

class ListHeaderView: UIView {
    
    //MARK:- Outlet Declaration
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    //MARK:- Initalizer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

