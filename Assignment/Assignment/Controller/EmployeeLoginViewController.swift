//
//  EmployeeLoginViewController.swift
//  Assignment
//
//  Created by Aradhana Banode on 07/11/20.
//

import UIKit
import CoreData

class EmployeeLoginViewController: UIViewController {
    var employeeObj:Employee?
    
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dojoiningDatePicker: UIDatePicker!
    @IBOutlet weak var dobirthDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        firstNameTextField.addTarget(self, action:#selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        lastNameTextField.addTarget(self, action:#selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action:#selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        self.title = "Employee Login Form"
        
        if employeeObj != nil {
            firstNameTextField.text = employeeObj?.firstName
            lastNameTextField.text = employeeObj?.lastName
            emailTextField.text = employeeObj?.email
            dobirthDatePicker.setDate(employeeObj!.dob!, animated: false)
            dojoiningDatePicker.setDate(employeeObj!.doj!, animated: false)
            
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    public func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    @IBAction func clickOnSaveButton(_ sender: Any) {
        if !validateEmailId(emailID: emailTextField.text!) {
            showAlert()
        }
        else{
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "Employee",
                                           in: managedContext)!
            if employeeObj != nil {
                let obj = managedContext.object(with: employeeObj!.objectID)
                obj.setValue(firstNameTextField.text!, forKeyPath: "firstName")
                obj.setValue(lastNameTextField.text!, forKeyPath: "lastName")
                obj.setValue(emailTextField.text!, forKeyPath: "email")
                obj.setValue(dojoiningDatePicker.date, forKeyPath: "doj")
                obj.setValue(dobirthDatePicker.date, forKeyPath: "dob")
            }
            else{
                let emp = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
                
                emp.setValue(firstNameTextField.text!, forKeyPath: "firstName")
                emp.setValue(lastNameTextField.text!, forKeyPath: "lastName")
                emp.setValue(emailTextField.text!, forKeyPath: "email")
                emp.setValue(dojoiningDatePicker.date, forKeyPath: "doj")
                emp.setValue(dobirthDatePicker.date, forKeyPath: "dob")
            }
            do {
                try managedContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController.init(title: "Error", message: "Please Enter a valid email address", preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
            self.emailTextField.becomeFirstResponder()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension EmployeeLoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        default:
            emailTextField.resignFirstResponder()
        }
        return true
    }
}


