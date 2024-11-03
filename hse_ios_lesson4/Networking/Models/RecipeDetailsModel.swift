//
//  RecipeDetailsModel.swift
//  hse_ios_lesson4
//
//  Created by Pavel Bobkov on 03.11.2024.
//

struct RecipeDetailsModel: Codable {
    let id: String?
    let title: String?
    let difficulty: String?
    let portion: String?
    let time: String?
    let description: String?
    let ingredients: [String?]
    let method: [[String: String]?]
    let image: String?
}
