//
//  parser.swift
//  colorie-counter
//
//
//

import Foundation

struct Parser {
    
    
    
    func getData() {
        let api = URL(string: "https://api.edamam.com/api/food-database/v2/parser?upc=044000032029&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")
        
        URLSession.shared.dataTask(with: api!) {
            data, response, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            do {
               let result = try JSONDecoder().decode(Product.self, from: data!)
                print(result)
            } catch {
                
            }
            
        }.resume()
    }
    
    func fetchData() {
        
        let apiA = URL(string: "https://api.edamam.com/api/food-database/v2/parser?ingr=pasta&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")
        let api = URL(string: "https://api.edamam.com/api/food-database/v2/parser?upc=044000032029&app_id=61b26e2c&app_key=c64c399826bc3152a50961dfc1a383ca")
        
        URLSession.shared.dataTask(with: apiA!) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let product = try JSONDecoder().decode(Product.self, from: data)
                
                print(product)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
