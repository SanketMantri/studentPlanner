//
//  CreateFriendsViewController.swift
//  Assignment
//
//  Created by Sanket Mantri on 13/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import UIKit
import CoreData

class CreateFriendsViewController: UIViewController {
    let appdel = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var ageBox: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var addressTextView: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var showMapBtn: UIButton!
    var friendsArray : NSMutableArray!
    var index : Int!
    var isFromCell : Bool!
    var friend : Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delBtn.isHidden = true
        showMapBtn.isHidden = true
        self.cancelBtn?.addTarget(self, action: #selector(self.cancelBtnPressed), for: .touchUpInside)
        if isFromCell == true {
            isFromCellTapped()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: DB Functions
    func storePersonInfo (firstName: String, lastName: String, age:String,address:String,gender:String) {
        let context = appdel.getContext()
        
        //retrieve the entity that we just created
        let entity = NSEntityDescription.entity(forEntityName: "Friends", in:
            context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the entity values
        transc.setValue(firstName, forKey: "firstname")
        transc.setValue(lastName, forKey: "lastname")
        transc.setValue(age, forKey: "age")
        transc.setValue(address, forKey: "address")
        transc.setValue(gender, forKey: "gender")
        //save the object
        do {
            try context.save()
            print("Data Saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch { }
    }
    func removeRecord () {
        let context = appdel.getContext()
        // delete everything in the table Person
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Friends")
        deleteFetch.predicate = NSPredicate(format: "firstname = %@", firstName.text!)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Data Deleted")
        } catch {
            print ("There was an error")
        }
    }
    @IBAction func showOnMapPressed(_ sender: Any) {
        shouldPerformSegue(withIdentifier: "navToMaos", sender: self)

    }
    func isFromCellTapped(){
        headerLabel.text = "Friends Details"
        showMapBtn.isHidden = false

        friend = friendsArray.object(at: index) as! Array<Any>
       firstName.isUserInteractionEnabled = false
        lastName.isUserInteractionEnabled = false
        ageBox.isUserInteractionEnabled = false
        addressTextView.isUserInteractionEnabled = false
        genderControl.isUserInteractionEnabled = false
        firstName.text = friend[0] as? String
        lastName.text = friend[1] as? String
        ageBox.text = friend[2] as? String
        addressTextView.text = friend[3] as? String
        let gen = friend[4] as? String
        if gen == "Male" {
            genderControl.selectedSegmentIndex = 0
        }
        else{
            genderControl.selectedSegmentIndex = 1
        }
        createBtn.setTitle("Edit", for: .normal)
        
        
    }
    @IBAction func delbtnPressed(_ sender: Any) {
        removeRecord()
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation
         */
    @objc func cancelBtnPressed(){
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "navToMaps")
        {
        
            let vc = segue.destination as! MapViewController
            vc.location = addressTextView.text!
            
        }
    }
    @IBAction func createBtnPressed(_ sender: Any) {
        if createBtn.titleLabel?.text == "Create"
        {
            var gen = " "
            if (genderControl.selectedSegmentIndex == 0){
                gen = "Male"
            }
            else if genderControl.selectedSegmentIndex == 1{
                gen = "Female"
            }
            storePersonInfo(firstName: firstName.text!, lastName: lastName.text!, age: ageBox.text!, address: addressTextView.text!, gender: gen)
            dismiss(animated: true, completion: nil)
        }
        else if createBtn.titleLabel?.text == "Edit"
        {
            delBtn.isHidden = false
            headerLabel.text = "Edit Friends Details"
            createBtn.setTitle("Save", for: .normal)

            friend = friendsArray.object(at: index) as! Array<Any>
            firstName.isUserInteractionEnabled = true
            lastName.isUserInteractionEnabled = true
            ageBox.isUserInteractionEnabled = true
            addressTextView.isUserInteractionEnabled = true
            genderControl.isUserInteractionEnabled = true
        }
        else if createBtn.titleLabel?.text == "Save"
        {
        }

    }
}
