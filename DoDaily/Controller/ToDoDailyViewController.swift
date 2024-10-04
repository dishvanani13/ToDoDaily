//
//  ViewController.swift
//  DoDaily
//
//  Created by Disha Limbani on 2024-09-26.
//

import UIKit

class ToDoDailyViewController: UITableViewController {

    //MARK - Variables
    
    var arryItem = ["milk","find ring", "grocery","garbage bag"]
    let userDefaults = UserDefaults.standard
    //MARK - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let data = userDefaults.array(forKey: "ToDoDaily") as? [String] {
            arryItem = data
        }
    }

    //TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        cell.textLabel?.text = arryItem[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Action AddButtion
    
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let data = textField.text {
                self.arryItem.append(data)
            }
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

