//
//  FoodInfo.swift
//  colorie-counter
//
//  Created by Юля on 5.06.21.
//

import Foundation
import Firebase

struct FoodInfo {
    
    private struct Constants {
        static let userIdKey = "userId"
        static let dateKey = "date"
        static let typeKey = "type"
        static let caloriesKey = "calories"
        static let proteinKey = "protein"
        static let fatKey = "key"
        static let chocdfKey = "chocdf"
    }
    
    let userId: String
    let date: String
    let type: String
    let calories: String
    let protein: String
    let fat: String
    let chocdf: String
    let ref: DatabaseReference?
    
    init (userId: String, date: String, type: String, calories: String, protein: String, fat: String, chocdf: String) {
        self.userId = userId
        self.date = date
        self.type = type
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.chocdf = chocdf
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any],
              let userId = snapshotValue[Constants.userIdKey] as? String,
              let date = snapshotValue[Constants.dateKey] as? String,
              let type = snapshotValue[Constants.typeKey] as? String,
              let calories = snapshotValue[Constants.caloriesKey] as? String,
              let protein = snapshotValue[Constants.proteinKey] as? String,
              let fat = snapshotValue[Constants.fatKey] as? String,
              let chocdf = snapshotValue[Constants.chocdfKey] as? String else { return nil }
        self.userId = userId
        self.date = date
        self.type = type
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.chocdf = chocdf
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> [String: Any] {
        return [Constants.userIdKey: userId, Constants.dateKey: date, Constants.typeKey: type, Constants.caloriesKey: calories, Constants.proteinKey: protein, Constants.fatKey: fat, Constants.chocdfKey: chocdf]
    }
    
}
