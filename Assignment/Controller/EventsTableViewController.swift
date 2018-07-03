//
//  EventsTableViewController.swift
//  Assignment
//
//  Created by Sanket Mantri on 13/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import UIKit
import CoreData

class EventsTableViewController: UITableViewController {
    let appdel = UIApplication.shared.delegate as! AppDelegate
    //Variable declaration
    var eventsDetailArray: NSMutableArray = []
    var eventsNameArray:NSMutableArray = []
    var eventDates: NSMutableArray = []

    @IBOutlet var eventTableView: UITableView!
    @IBOutlet weak var eventsNavBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsNavBar.title = "Events"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        getEventsInfo()
        eventTableView.reloadData()
        
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
        return eventsNameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = eventsNameArray[indexPath.row] as? String
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy HH:mm a"
        
        let date = dateFormater.string(from: Date())
        print(date)
        //let t = dateFormatter.date(from: date)
        if eventsDetailArray.count > 0 {
            let eventDate = dateFormater.string(from: eventDates[indexPath.row] as! Date)
            if date > eventDate {
                cell.backgroundColor = UIColor.green
            }
            else if date < eventDate{
                cell.backgroundColor = UIColor.cyan
                
            }
        }
        // Configure the cell...
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        shouldPerformSegue(withIdentifier: "showEventsDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showEventsDetails")
        {
            let index = self.eventTableView.indexPathForSelectedRow
            let indexNumber = index?.row //0,1,2,3
            let vc = segue.destination as! CreateEventViewController
            vc.eventsArray = eventsDetailArray
            vc.index = indexNumber
            vc.isFromCell = true
        }
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    //MARK:- DB Functions
    func getEventsInfo()
    {
        eventsNameArray.removeAllObjects()
        eventsDetailArray.removeAllObjects()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: appdel.getContext())
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do
        {
            let result = try appdel.getContext().fetch(fetchRequest)
            
            for event in result as! [NSManagedObject]
            {
                let datetime = String(event.value(forKey: "datetime") as! String)
                let location = String(event.value(forKey: "location") as! String)
                let name = String(event.value(forKey: "name") as! String)
                
               
                let eventDetail=[datetime,location,name]
                let eventName = name
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd MMM yyyy, hh:MM a"
                let formatedDate = dateFormat.date(from: datetime)
                eventDates.add(formatedDate!)
                eventsDetailArray.add(eventDetail)
                eventsNameArray.add(eventName)
                eventTableView.reloadData()
                
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
            "Events")
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
        eventsNameArray.removeAllObjects()
        eventsDetailArray.removeAllObjects()
        eventTableView.reloadData()
        let alertView = UIAlertController(title: "Organiser App", message: "All Events deleted", preferredStyle: .alert)
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
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
