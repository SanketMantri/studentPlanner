//
//  FriendsTableViewController.swift
//  Assignment
//
//  Created by Sanket Mantri on 12/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import UIKit
import CoreData

class FriendsTableViewController: UITableViewController {
    let appdel = UIApplication.shared.delegate as! AppDelegate

    //Variable declaration
    var friendsDetailArray:NSMutableArray = []
    var friendsNameArray:NSMutableArray = []
    //Outlet Declaration
    @IBOutlet var friendsTableView: UITableView!
    @IBOutlet weak var friendsNavBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsNavBar.title = "Friends"

        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        getFriendInfo()
        friendsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsNameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = friendsNameArray[indexPath.row] as? String
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        shouldPerformSegue(withIdentifier: "showFriendsDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFriendsDetails")
        {
        let index = self.friendsTableView.indexPathForSelectedRow
        let indexNumber = index?.row //0,1,2,3
        let vc = segue.destination as! CreateFriendsViewController
        vc.friendsArray = friendsDetailArray
        vc.index = indexNumber
        vc.isFromCell = true
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

 
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 

 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 */
     func getFriendInfo()
     {
        friendsNameArray.removeAllObjects()
        friendsDetailArray.removeAllObjects()
     
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
     // Create Entity Description
     let entityDescription = NSEntityDescription.entity(forEntityName: "Friends", in: appdel.getContext())
     
     // Configure Fetch Request
     fetchRequest.entity = entityDescription
     
     do
     {
     let result = try appdel.getContext().fetch(fetchRequest)
     
        for friend in result as! [NSManagedObject]
         {
             let firstName = String(friend.value(forKey: "firstname") as! String)
             let lastname = String(friend.value(forKey: "lastname") as! String)
             let gender = String(friend.value(forKey: "gender") as! String)
             let age = String(friend.value(forKey: "age") as! String)
             let address = String(friend.value(forKey: "address") as! String)
            let friendDetail=[firstName,lastname,age,address,gender]
             let friendName = firstName+" " + lastname
         friendsDetailArray.add(friendDetail)
         friendsNameArray.add(friendName)
        friendsTableView.reloadData()


         }
     }
     catch
     {
     let fetchError = error as NSError
     print(fetchError)
     }
 }
    func removeRecords () {
        let context = appdel.getContext()
        // delete everything in the table Person
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Friends")
        //        deleteFetch.predicate = NSPredicate(format: "name = %@", test)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Data Deleted")
        } catch {
            print ("There was an error")
        }
    }
    //MARK: - Button Actions
    
   
    @IBAction func trashBtnPressed(_ sender: Any) {
        removeRecords()
        friendsNameArray.removeAllObjects()
        friendsDetailArray.removeAllObjects()
        friendsTableView.reloadData()
        let alertView = UIAlertController(title: "Organiser App", message: "All Friends deleted", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
        
    }

 /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
*/
}
