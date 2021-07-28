//
//  ViewController+TableViewDelegate.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation
import UIKit

//MARK:- Table View Delegates
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(identifier: Constants.shared.AddUpdateVC) as? AddUpdateViewController{
            vc.updatedDatabaseDelegate = self
            vc.titleType = arrHeaderTitle[indexPath.section].rawValue
            vc.isAddData = false
            let ent = self.arrTaskData[arrHeaderTitle[indexPath.section].rawValue]?[indexPath.row]
            vc.entUpdate = ListDataStruct(id: ent?.id ?? "", title: ent?.title ?? "", descriptions: ent?.descriptions ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- Table View Header setup
extension ViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed(Constants.shared.ListHeaderView, owner: self, options: nil)?.first as! ListHeaderView
        headerView.btnAdd.tag = section
        headerView.btnAdd.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        headerView.lblTitleHeader.text = self.arrHeaderTitle[section].rawValue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
