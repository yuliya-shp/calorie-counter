//
//  Model.swift
//  colorie-counter
//
//
//

import Foundation

struct Product: Codable {
    let text: String?
    let hints: [Hint?]
}

// MARK: - Hint
struct Hint: Codable {
    let food: Food?
}

// MARK: - Food
struct Food: Codable {
    let foodID, label: String?
    let nutrients: Nutrients?
    let brand, category, categoryLabel, foodContentsLabel: String?
    let image: String?
    let servingsPerContainer: Double?
}

struct Nutrients: Codable {
    let ENERC_KCAL: Double?
    let PROCNT: Double?
    let FAT: Double?
    let CHOCDF: Double?
    let FIBTG: Double?
}



