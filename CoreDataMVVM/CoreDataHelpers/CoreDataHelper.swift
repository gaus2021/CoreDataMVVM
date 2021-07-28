//
//  CoreDataHelper.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation
import CoreData

protocol CoreDataBaseProtocol {
    func addTask(data: ListDataStruct,entityName: String,completionHandler: @escaping (dataResponse) -> Void)
}

struct CoreDataHelpers: CoreDataBaseProtocol {
    
    
    //MARK:- Adding values in Core Data
    
    func addTask(data: ListDataStruct, entityName: String,completionHandler: @escaping (dataResponse) -> Void) {
        let taskEntity = PersistentStorage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: taskEntity)
        let newUser = NSManagedObject(entity: entity!, insertInto: taskEntity)
        newUser.setValue(data.id, forKey: ListDataEnums.id.rawValue)
        newUser.setValue(data.title, forKey: ListDataEnums.title.rawValue)
        newUser.setValue(data.descriptions, forKey: ListDataEnums.descriptions.rawValue)
        PersistentStorage.shared.saveContext { data in
            if data.isSuccess == false { //Error while saving  data
                completionHandler(dataResponse(isSuccess: false, errorMsg: "Error while saving data", msg: "Error while saving data"))
            } else {  //Data Saved Successfully
                completionHandler(dataResponse(isSuccess: true, errorMsg: "Data Saved Successfully", msg: "Data Saved Successfully"))
            }
        }
    }
    
    //MARK:- Fetching all values from Core data
    func getAllTaskData(entityName: String,completionHandler: @escaping (dataResponse,[ListDataStruct]?) -> Void) {
        let fetchQuest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let result = PersistentStorage.shared.fetchManagedObject(fetchRequest: fetchQuest){
            let data = ConvertToListData(arrManagedObject: result)
            completionHandler(dataResponse(isSuccess: true, errorMsg: "Data Found", msg: "Data Found"),data)
        }
        completionHandler(dataResponse(isSuccess: false, errorMsg: "No Data Found", msg: "No Data"),nil)
    }
    
    //MARK:- Deleting data from Core data
    func getDeleteTaskData(entityName: String,id: String,completionHandler: @escaping (dataResponse?) -> Void) {
        let fetchQuest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchQuest.returnsObjectsAsFaults = false
        fetchQuest.predicate = NSPredicate(format: "id = %@", id)
        if let result = PersistentStorage.shared.fetchManagedObject(fetchRequest: fetchQuest){
            for obj in result {
                PersistentStorage.shared.context.delete(obj)
            }
            PersistentStorage.shared.saveContext { response in
                completionHandler(dataResponse(isSuccess: true, errorMsg: "", msg: "Task Deleted Successfully"))
            }
        }
        completionHandler(dataResponse(isSuccess: false, errorMsg: "Error while deleting Task", msg: ""))
    }
    
    //MARK:- Updating data from Core data
    func updatingTaskData(entityName: String,id: String,singleEnt:AddViewViewModel ,completionHandler: @escaping (dataResponse?) -> Void) {
        let fetchQuest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchQuest.returnsObjectsAsFaults = false
        fetchQuest.predicate = NSPredicate(format: "id = %@", id)
        if let result = PersistentStorage.shared.fetchManagedObject(fetchRequest: fetchQuest){
            for obj in result {
                obj.setValue(singleEnt.id, forKey: ListDataEnums.id.rawValue)
                obj.setValue(singleEnt.title, forKey: ListDataEnums.title.rawValue)
                obj.setValue(singleEnt.descriptions, forKey: ListDataEnums.descriptions.rawValue)
            }
            PersistentStorage.shared.saveContext { response in
                completionHandler(dataResponse(isSuccess: true, errorMsg: "", msg: "Task Updated Successfully"))
            }
        }
        completionHandler(dataResponse(isSuccess: false, errorMsg: "Error while Updating Task", msg: ""))
    }
    
    //MARK:- Converting nsmanaged object to List Data Struct
    private func ConvertToListData(arrManagedObject: [NSManagedObject]) -> [ListDataStruct]?{
        var arrListData = [ListDataStruct]()
        for obj in arrManagedObject {
            let id = obj.value(forKey: ListDataEnums.id.rawValue)
            let title = obj.value(forKey: ListDataEnums.title.rawValue)
            let desc = obj.value(forKey: ListDataEnums.descriptions.rawValue)
            arrListData.append(ListDataStruct(id: id as! String, title: title as! String, descriptions: desc as! String))
        }
        return arrListData
    }
    
}
