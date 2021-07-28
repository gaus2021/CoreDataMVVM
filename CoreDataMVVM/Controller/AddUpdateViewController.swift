//
//  AddUpdateViewController.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import UIKit

protocol validateData {
    func validateAddedData(isSuccess: Bool, error: String)
    func addDataInCoreData(isSuccess: Bool, error: String)
    func updateDataInCoreData(isSuccess: Bool, error: String)
}

class AddUpdateViewController: UIViewController, validateData {
    
    //MARK:- Outlet Declaration
    @IBOutlet weak var tfTitle: BindingTextField! {
        didSet {
            tfTitle.bind { value in
                self.addViewViewModel?.title = value
            }
        }
    }
    @IBOutlet weak var tfDescriptions: BindingTextField! {
        didSet {
            tfDescriptions.bind { value in
                self.addViewViewModel?.descriptions = value
            }
        }
    }
    
    @IBOutlet weak var btnAdd: UIButton!
    
    //MARK:- Variable Decalration
    var isAddData : Bool = true
    var addViewViewModel: AddViewViewModel?
    var addViewVMDataValidation: AddViewVMDataValidation?
    var titleType: String?
    weak var updatedDatabaseDelegate: updatedDatabaseProtocol?
    var entUpdate : ListDataStruct?
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- Initial Setup
    func initialSetup() {
        btnAdd.setTitle(isAddData == true ? "Add" : "Update", for: .normal)
        self.title = titleType ?? ""
        self.addViewViewModel = AddViewViewModel()
        self.addViewVMDataValidation = AddViewVMDataValidation()
        self.addViewVMDataValidation?.delegate = self
        if isAddData == false {
            self.addViewViewModel?.id = entUpdate?.id
            self.addViewViewModel?.title = entUpdate?.title
            self.addViewViewModel?.descriptions = entUpdate?.descriptions
            self.tfTitle.text = self.addViewViewModel?.title
            self.tfDescriptions.text = self.addViewViewModel?.descriptions
        }
    }

    //MARK:- Button Tapped Methods
    @IBAction func btnAddTapped(_ sender: UIButton) {
        if self.isAddData == true {
            self.addViewVMDataValidation?.isAddedDataValid(ent: self.addViewViewModel)
        } else {
            self.addViewVMDataValidation?.updatingDataInCoreData(ent: self.addViewViewModel, entName: self.titleType ?? "")
        }
    }
    
    ///Go back to previous screena after showing toast
    func backToPreviousScreen(msg: String) {
        self.showToast(message: msg)
        self.updatedDatabaseDelegate?.fetchDataFromDB()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK:- validateData Protocol Methods
extension AddUpdateViewController {
    
    func validateAddedData(isSuccess: Bool, error: String) {
        if isSuccess == true {
            self.addViewViewModel?.id = UUID().uuidString
            self.addViewVMDataValidation?.addDataInCoreData(ent: self.addViewViewModel, entName: titleType!)
        } else {
            self.showToast(message: error)
        }
    }
    
    func addDataInCoreData(isSuccess: Bool, error: String) {
        if isSuccess == true {
            self.backToPreviousScreen(msg: error)
        } else {
            self.showToast(message: error)
        }
    }
    
    func updateDataInCoreData(isSuccess: Bool, error: String) {
        if isSuccess == true {
            self.backToPreviousScreen(msg: error)
        }
    }
}
