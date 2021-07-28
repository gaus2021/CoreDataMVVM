//
//  AddViewViewModel.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation

//MARK:- View Model
class AddViewViewModel{
    var id: String?
    var title: String?
    var descriptions: String?
}

//MAR:- Data Validation View Model
struct AddViewVMDataValidation {
    
    var delegate: validateData?
    
    ///Validation Data
    func isAddedDataValid(ent: AddViewViewModel?) {
        if ent?.title == "" || ent?.title == nil{
            delegate?.validateAddedData(isSuccess: false, error: "Please Enter Valid Title")
        } else if ent?.title?.count ?? 0 < 3 {
            delegate?.validateAddedData(isSuccess: false, error: "Title Should be more than 3 characters")
        } else {
            delegate?.validateAddedData(isSuccess: true, error: "Success")
        }
    }
    
    ///Adding Data to Core Data
    func addDataInCoreData(ent: AddViewViewModel?, entName: String) {
        CoreDataHelpers().addTask(data: ListDataStruct(id: ent?.id ?? "", title: ent?.title ?? "", descriptions: ent?.descriptions ?? ""), entityName: entName) { data in
            if data.isSuccess == true {
                delegate?.addDataInCoreData(isSuccess: data.isSuccess, error: data.msg)
            } else {
                delegate?.addDataInCoreData(isSuccess: false, error: data.errorMsg)
            }
        }
    }
    
    ///Updating values in Core data
    func updatingDataInCoreData(ent: AddViewViewModel?, entName: String) {
        CoreDataHelpers().updatingTaskData(entityName: entName, id: ent?.id ?? "", singleEnt: ent!) { response in
            if response?.isSuccess == true {
                self.delegate?.updateDataInCoreData(isSuccess: true, error: response?.msg ?? "")
            } else {
                self.delegate?.updateDataInCoreData(isSuccess: false, error: response?.errorMsg ?? "")
            }
        }
    }
}

