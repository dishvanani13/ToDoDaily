//
//  ViewController.swift
//  DoDaily
//
//  Created by Disha Limbani on 2024-09-26.
//

import UIKit

class ToDoDailyViewController: UITableViewController {

    //MARK - Variables
    
    var arryItem = [Item]()
    let userDefaults = UserDefaults.standard
    //MARK - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let data = userDefaults.object(forKey: "ToDoDaily") as? [String] {
//            arryItem = data
//        }
        let newItem = Item()
        newItem.title = "Mixer"
        arryItem.append(newItem)
        
    }

    //TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        cell.textLabel?.text = arryItem[indexPath.row].title
        if arryItem[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        if arryItem[indexPath.row].done == false {
            arryItem[indexPath.row].done = true
        }else {
            arryItem[indexPath.row].done = false
        }
        //if arryItem[in]
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Action AddButtion
    
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newitem = Item()
            newitem.title = textField.text!
            self.arryItem.append(newitem)
           
            self.userDefaults.setValue(self.arryItem, forKey: "ToDoDaily")
            self.tableView.reloadData()
        }
        
        alert.addTextField { uitextfield in
            uitextfield.placeholder = "Add New Item"
            textField = uitextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

