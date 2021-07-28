//
//  ViewController+TableViewDataSource.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation
import UIKit

//MARK:- Table View Datasource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTaskData[arrHeaderTitle[section].rawValue]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewList.dequeueReusableCell(withIdentifier: Constants.shared.ListViewTVC) as! ListViewTableViewCell
        let ent = self.arrTaskData[arrHeaderTitle[indexPath.section].rawValue]?[indexPath.row]
        cell.lblTitle.text = ent?.title
        cell.lblDescription.text = ent?.descriptions
        cell.btnDelete.accessibilityHint = String(indexPath.section)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
