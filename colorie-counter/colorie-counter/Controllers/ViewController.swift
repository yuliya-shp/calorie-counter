//
//  ViewController.swift
//  colorie-counter
//
//
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var searchViewController: SearchViewController?
    
    let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
    
    var user: User!
    var ref: DatabaseReference!
    var refFood: DatabaseReference!
    var date: String!
    var cal = ""
    var calCount = 0.0
    
    var foodInfo = [FoodInfo]()
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date = currentDate()
        dateLabel.text = String(date)
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "user")
        refFood = Database.database().reference(withPath: "user").child(String(user.uid)).child(date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        date = currentDate()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "user")
        refFood = Database.database().reference(withPath: "user").child(String(user.uid)).child(date)
        
        refFood.observe(.value) { [weak self] snapshot in
            var foodInfo = [FoodInfo]()
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot, let food = FoodInfo(snapshot: snapshot) else { continue }
                foodInfo.append(food)
            }
            self?.foodInfo = foodInfo
            
            self!.navigationItem.setHidesBackButton(true, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refFood.removeAllObservers()
    }
    
    @IBAction func signoutTap(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popToRootViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSearchBrk" {
            let vc = segue.destination as? SearchViewController
            vc?.type = "Breakfast"
        } else if segue.identifier == "goSearchLunch" {
            let vc = segue.destination as? SearchViewController
            vc?.type = "Lunch"
        } else if segue.identifier == "goSearchDinner" {
            let vc = segue.destination as? SearchViewController
            vc?.type = "Dinner"
        } else if segue.identifier == "goSearchSnack" {
            let vc = segue.destination as? SearchViewController
            vc?.type = "Snack"
        }
    }
    
    func currentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
}

