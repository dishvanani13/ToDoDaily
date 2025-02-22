//
//  ViewController.swift
//  DoDaily
//
//  Created by Disha Limbani on 2024-09-26.
//

import UIKit
import CoreData

class ToDoDailyViewController: UITableViewController {

    //MARK - Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    var arryItem = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadCoreData()
        }
    }
    // User Defaults just use to save the standerd data type not custom object
   // let userDefaults = UserDefaults.standard
    // for Coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // App file path to store small data
    //let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //MARK - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //call to collect data from userdefaults
//        if let data = userDefaults.object(forKey: "ToDoDaily") as? [Item] {
//            arryItem = data
//        }
        // for small data
//        let newItem = Item()
//        newItem.title = "Mixer"
//        arryItem.append(newItem)
       // loadData()
        
        
       
        
        //SearchBar Delegate
       searchBar.delegate = self
        
    }

    //TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        let item = arryItem[indexPath.row]
        cell.textLabel?.text = item.title
        // Check checkmark is available then visible it
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        context.delete(arryItem[indexPath.row])
        arryItem.remove(at: indexPath.row)
        
        
       // arryItem[indexPath.row].done = !arryItem[indexPath.row].done
       
        SaveItemData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Action AddButtion
    
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // coredata
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.arryItem.append(newitem)
            
            // small data
           // set appended array in userdefaults for small list
            //self.userDefaults.setValue(self.arryItem, forKey: "ToDoDaily")
            self.SaveItemData()
        }
        
        alert.addTextField { uitextfield in
            uitextfield.placeholder = "Add New Item"
            textField = uitextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func SaveItemData(){
      //  small data
       // let endoer = PropertyListEncoder()
        do{
            //small data
//            let data = try endoer.encode(arryItem)
//            try data.write(to: datafilePath!)
            try context.save()
        }catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
// for small data
//    func loadData(){
//       if let data = try? Data(contentsOf: datafilePath!) {
//           let decoder = PropertyListDecoder()
//           do {
//               arryItem = try decoder.decode([Item].self, from: data)
//               
//           }catch{
//               print("Decodable Error : \(error)")
//           }
//        }
   // }
    func loadCoreData(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil){
        
        let cateorypredicates = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicates = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [cateorypredicates, additionalPredicates])
        } else {
            request.predicate = cateorypredicates
        }
        
        do{
            arryItem = try context.fetch(request)
        } catch {
            print("Error for CoreData load :  \(error)")
        }
        tableView.reloadData()
    }
    
}
extension ToDoDailyViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do{
            arryItem = try context.fetch(request)
        }catch {
            print("Error: \(error)")
        }
        loadCoreData(with: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCoreData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
   
}

