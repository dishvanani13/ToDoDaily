//
//  CategoryTableViewController.swift
//  DoDaily
//
//  Created by Disha Limbani on 2024-10-20.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
//Variable
    var categories = [Category]()
   
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    //Save Data
    func saveCategory(){
        do {
            try context.save()
        }catch{
            print("Error print for Category : \(error)")
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error fetching Category : \(error) ")
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = categories[indexPath.row].name
        cell.contentConfiguration = content
        //cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoDailyViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func CategoryAddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: ".....", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            let newCategory = Category(context: context)
            newCategory.name = textField.text
            categories.append(newCategory)
            saveCategory()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
