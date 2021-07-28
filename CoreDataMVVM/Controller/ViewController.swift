//
//  ViewController.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import UIKit

protocol updatedDatabaseProtocol : class {
    func fetchDataFromDB()
}

class ViewController: UIViewController,updatedDatabaseProtocol {
    
    //MARK:- outlet Declaration
    @IBOutlet weak var tblViewList: UITableView!
    
    //MARK:- Declaration
    var arrHeaderTitle = [HeaderTitle.Today, HeaderTitle.Tomorrow, HeaderTitle.Upcoming]
    var arrTaskData: [String:[ListDataStruct]] = [String:[ListDataStruct]]()
    
    //MARK:- View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- Custom funtions
    func initialSetup() {
        tblViewList.register(UINib(nibName: Constants.shared.ListViewTVC, bundle: Bundle.main), forCellReuseIdentifier: Constants.shared.ListViewTVC)
        tblViewList.tableFooterView = UIView()
        getData()
    }
    
    func fetchDataFromDB() {
        getData()
    }
    
    func getData() {
        self.arrTaskData.removeAll()
        for obj in arrHeaderTitle {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            CoreDataHelpers().getAllTaskData(entityName: obj.rawValue) { response, data in
                if response.isSuccess == true { // Got data from DB
                    if let arrayData = data {
                        self.arrTaskData.updateValue(arrayData, forKey: obj.rawValue)
                        dispatchGroup.leave()
                    }
                } else { // No Data
                    print(response.msg)
                }
            }
            dispatchGroup.wait()
        }
        DispatchQueue.main.async {
            self.tblViewList.reloadData()
        }
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(identifier: Constants.shared.AddUpdateVC) as? AddUpdateViewController{
            vc.updatedDatabaseDelegate = self
            vc.titleType = arrHeaderTitle[sender.tag].rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        let section = Int(sender.accessibilityHint ?? "0")
            ?? 0
        let id = self.arrTaskData[arrHeaderTitle[section].rawValue]?[sender.tag].id ?? ""
        CoreDataHelpers().getDeleteTaskData(entityName: arrHeaderTitle[section].rawValue, id: id) { response in
            if response?.isSuccess == true {
                print("data delete Successfully")
                self.arrTaskData[self.arrHeaderTitle[section].rawValue]?.remove(at: sender.tag)
                DispatchQueue.main.async {
                    self.tblViewList.reloadData()
                }
            } else {
                print("Error")
            }
        }
    }
}
