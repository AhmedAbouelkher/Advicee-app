//
//  File.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let advice = try? newJSONDecoder().decode(Advice.self, from: jsonData)

import Foundation

// MARK: - Advice
struct Advice: Codable {
    let slip: Slip
}

// MARK: - Slip
struct Slip: Codable {
    let id: Int
    let advice: String
}
