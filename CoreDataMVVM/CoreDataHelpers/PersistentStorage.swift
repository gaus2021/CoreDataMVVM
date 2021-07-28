//
//  PersistentStorage.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation
import CoreData

final class PersistentStorage
{

    private init(){}
    static let shared = PersistentStorage()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataMVVM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support
    func saveContext(completionHandler: @escaping (dataResponse) -> Void){
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved Successfully")
                completionHandler(dataResponse(isSuccess: true, errorMsg: "", msg: "Data Saved Successfully"))
            } catch {
                completionHandler(dataResponse(isSuccess: false, errorMsg: error.localizedDescription, msg: "Error while saving data"))
            }
        }
    }

    func fetchManagedObject(fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> [NSManagedObject]?
    {
        do {
            
            guard let result = try PersistentStorage.shared.context.fetch(fetchRequest!) as? [NSManagedObject]else {return nil}
            
            return result

        } catch let error {
            debugPrint(error)
        }
        
        return nil
    }
}
