//
//  DetailViewController.swift
//  colorie-counter
//
//
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var user: User!
    var ref: DatabaseReference!
    var foodInfo = [FoodInfo]()
    var isBarcode = false
    var barcode = ""
    
    var cal: Double!
    var protein: Double!
    var fat: Double!
    var carbs: Double!
    
    var name: String = ""
    var type: String = ""
    private var products: [Hint?] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var grammTF: UITextField!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var procntLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var chocdfLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var fatView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = name.capitalized.uppercased()
        typeLabel.text = type
        dateLabel.text = currentDate()
        fetchData()
        
        addBtn.layer.cornerRadius = 14
        calView.layer.cornerRadius = 14
        proteinView.layer.cornerRadius = 14
        carbsView.layer.cornerRadius = 14
        fatView.layer.cornerRadius = 9
        //print(products.count)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "user").child(String(user.uid)).child(dateLabel.text!)
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let calorieText = calorieLabel.text,
              let procntText = procntLabel.text,
              let fatText = fatLabel.text,
              let chocdfText = chocdfLabel.text,
              let dateText = dateLabel.text,
              let typeText = typeLabel.text,
              let uid = self.user?.uid else { return }
        let foodInfo = FoodInfo(userId: uid, date: dateText, type: typeText, calories: calorieText, protein: procntText, fat: fatText, chocdf: chocdfText)
        let foodRef = self.ref.child(foodInfo.type.lowercased())
        foodRef.setValue(foodInfo.convertToDictionary())
    }
    
    @IBAction func editGrammTextField(_ sender: UITextField) {
        self.calorieLabel.text = String(cal * (Double(sender.text!) ?? 1.0))
        self.procntLabel.text = String(protein * (Double(sender.text!) ?? 1.0))
        self.fatLabel.text = String(fat * (Double(sender.text!) ?? 1.0))
        self.chocdfLabel.text = String(carbs * (Double(sender.text!) ?? 1.0))
    }
    
    func setLink (value: Bool) -> URL {
        if value {
            return barcodeLink(barcode: barcode)
        } else {
            return ingrLink(value: name)
        }
    }
    
    func ingrLink(value: String) -> URL {
        let value = value.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "https://api.edamam.com/api/food-database/v2/parser?ingr=\(value)&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")!
    }
    
    func barcodeLink(barcode: String) -> URL {
        isBarcode = false
        return URL(string: "https://api.edamam.com/api/food-database/v2/parser?upc=\(barcode)&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")!
    }
    
    func fetchData() {
        URLSession.shared.dataTask(with: setLink(value: isBarcode)) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let product = try JSONDecoder().decode(Product.self, from: data)
                self.products = product.hints
                print(product)
                print(self.products)
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.cal = Double(round(1000*(self.products[0]?.food?.nutrients!.ENERC_KCAL)!)/1000) //Double(round(1000*x)/1000)
                self.calorieLabel.text = String(self.cal)
                self.protein = Double(round(1000*(self.products[0]?.food?.nutrients!.PROCNT)!)/1000)
                self.procntLabel.text = String(self.protein)
                self.fat = Double(round(1000*(self.products[0]?.food?.nutrients!.FAT)!)/1000)
                self.fatLabel.text = String(self.fat)
                self.carbs = Double(round(1000*(self.products[0]?.food?.nutrients!.CHOCDF)!)/1000)
                self.chocdfLabel.text = String(self.carbs)
            }
        }.resume()
    }
    
    func currentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

}
