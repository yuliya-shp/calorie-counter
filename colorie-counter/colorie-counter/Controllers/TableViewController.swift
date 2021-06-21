//
//  TableViewController.swift
//  colorie-counter
//
//
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    private var products: [Hint?] = []


    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        fetchData()
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(products.count)
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = products[indexPath.row]?.food?.label
        print(products[indexPath.row]?.food)
        return cell
    }

    func fetchData() {
        
        let api = URL(string: "https://api.edamam.com/api/food-database/v2/parser?ingr=pasta&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")
        
        URLSession.shared.dataTask(with: api!) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let product = try JSONDecoder().decode(Product.self, from: data)
                self.products = product.hints
                //print(product)
                //print(self.products[3]?.food?.label)
                //print(self.products)
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }

}
