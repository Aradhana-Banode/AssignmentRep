//
//  ViewController.swift
//  Assignment
//
//  Created by Aradhana Banode on 07/11/20.
//

import UIKit
import CoreData
import Foundation
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var employees: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    func fetchData(){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Employee")
        do {
            employees = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        for item in employees {
            let item1  = item as! Employee
            print(item1.doj!)
        }
    }
    @objc func editTapped(empObj : Employee){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let empFormVC = storyBoard.instantiateViewController(identifier: "EmployeeLogin") as! EmployeeLoginViewController
        empFormVC.employeeObj = empObj
        self.navigationController?.pushViewController(empFormVC, animated: true)
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        let item1  = employees[indexPath.row] as! Employee
        cell.nameLabel.text = item1.firstName! + " " + item1.lastName!
        cell.emailLabel.text = item1.email
    
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: item1.doj!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "EEEE yyyy-MM-dd HH:mm:ss"
        let myString1 = formatter1.string(from: item1.doj!)
        let yourDate1 = formatter1.date(from: myString1)
        formatter1.dateFormat = "dd"
        let myStringafd1 = formatter1.string(from: yourDate1!)
        
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "EEEE yyyy-MM-dd HH:mm:ss"
        let myString2 = formatter2.string(from: item1.doj!)
        let yourDate2 = formatter2.date(from: myString2)
        formatter2.dateFormat = "EEEE"
        let myStringafd2 = formatter2.string(from: yourDate2!)
    
        cell.dateLabel.text = myStringafd
        cell.dayLabel.text = myStringafd1
        cell.weekDayLabel.text = myStringafd2
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let item = self.employees[indexPath.row] as! Employee
            self.editTapped(empObj: item)
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { [weak self] (action, indexPath) in
            let item = self!.employees[indexPath.row] as! Employee
            self!.deleteRecords(objectId:item.objectID)
        })
        return [deleteAction, editAction]
    }
    func deleteRecords(objectId : NSManagedObjectID) -> () {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Employee")
        let objects = try! managedContext.fetch(fetchRequest)
        for obj in objects {
            if obj.objectID == objectId {
                managedContext.delete(obj)
            }
        }

            do {
                try managedContext.save()
                self.fetchData()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {

            }

    }

}
