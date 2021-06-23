//
//  SearchViewController.swift
//  colorie-counter
//
//
//

import UIKit

class SearchViewController: UIViewController {
    
    private var products: [String] = []
    var type = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        print(type)
        
    }
    
    @IBAction func searchingTF(_ sender: UITextField) {
        fetchData(value: sender.text?.replacingOccurrences(of: " ", with: "%20") ?? "")
    }
    
    func fetchData(value: String) {
        
        let api = URL(string:"https://api.edamam.com/auto-complete?q=\(value)&limit=10&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")
        
        URLSession.shared.dataTask(with: api!) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let product = try JSONDecoder().decode([String].self, from: data)
                self.products = product
                print(product)
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

extension SearchViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let vc = segue.destination as? DetailViewController
            vc?.name = products[indexPath.row]
            vc?.type = type
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].uppercased()
        return cell
    }
    
    
}
