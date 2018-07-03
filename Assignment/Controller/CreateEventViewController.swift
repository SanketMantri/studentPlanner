//
//  CreateEventViewController.swift
//  Assignment
//
//  Created by Sanket Mantri on 13/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import UIKit
import CoreData


class CreateEventViewController: UIViewController {
    
    let appdel = UIApplication.shared.delegate as! AppDelegate


    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var dateTextView: UITextField!
    @IBOutlet weak var addresstextview: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    var datePickerView  : UIDatePicker = UIDatePicker()
    var eventsArray : NSMutableArray = []
    var index : Int!
    var isFromCell : Bool!
    var event : Array<Any>!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnPressed), for: .touchUpInside)
        delBtn.isHidden = true
        if isFromCell == true
        {
            isFromCellTapped()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - Date Functions
    @IBAction func dateEditingDidEnd(_ sender: Any) {
        dateTextView.resignFirstResponder()
    }
    @IBAction func dateTextViewTapped(_ sender: UITextField) {
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        dateTextView.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: UIControlEvents.valueChanged)
    }
   
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, hh:MM a"
        dateTextView.text = dateFormatter.string(from: sender.date)
    }

    
    func isFromCellTapped(){
        event = eventsArray.object(at: index) as! Array<Any>
        eventName.isUserInteractionEnabled = false
        dateTextView.isUserInteractionEnabled = false
        addresstextview.isUserInteractionEnabled = false
        eventName.text = event[2] as? String
        dateTextView.text = event[0] as? String
        addresstextview.text = event[1] as? String
        createBtn.setTitle("Edit", for: .normal)
        
        
    }
    //MARK: - DB func
    func storeEventInfo (name: String, location: String, dateTime:String) {
        let context = appdel.getContext()
        //retrieve the entity that we just created
        let entity = NSEntityDescription.entity(forEntityName: "Events", in:
            context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the entity values
        transc.setValue(name, forKey: "name")
        transc.setValue(location, forKey: "location")
        transc.setValue(dateTime, forKey: "datetime")
        //save the object
        do {
            try context.save()
            print("Event Data Saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch { }
    }
//    func getEventsInfo()
//    {
//        let moc : NSManagedObjectContext = NSManagedObjectContext()
//        let friendsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        // Create Entity Description
//        let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: appdel.getContext())
//
//        // Configure Fetch Request
//        fetchRequest.entity = entityDescription
//
//        do
//        {
//            let result = try moc.execute(friendsFetch)
//            result[0]
//
//
//        }
//        catch
//        {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//    }
    func updateEventInfo (name: String, location: String, dateTime:String) {
        let context = appdel.getContext()
        //retrieve the entity that we just created
       
        do {
            try context.save()
            print("Event Data Saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch { }
    }
    func removeRecord () {
        let context = appdel.getContext()
        // delete everything in the table Person
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Events")
        deleteFetch.predicate = NSPredicate(format: "name = %@", eventName.text!)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Data Deleted")
        } catch {
            print ("There was an error")
        }
    }

    
    // MARK: - Button Actions
     @objc func cancelBtnPressed(){
     dismiss(animated: true, completion: nil)
     }
    @IBAction func delBtnPressed(_ sender: Any) {
        removeRecord()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func createButtonPressed(_ sender: Any) {
        if createBtn.titleLabel?.text == "Create" {
            storeEventInfo(name: eventName.text!, location: addresstextview.text!, dateTime: dateTextView.text!)
            self.dismiss(animated: true, completion: nil)
        }
        
        else if createBtn.titleLabel?.text == "Edit"
        {
            createBtn.setTitle("Save", for: .normal)
            delBtn.isHidden = false
            eventName.isUserInteractionEnabled = true
            dateTextView.isUserInteractionEnabled = true
            addresstextview.isUserInteractionEnabled = true
        }
        
    }
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
