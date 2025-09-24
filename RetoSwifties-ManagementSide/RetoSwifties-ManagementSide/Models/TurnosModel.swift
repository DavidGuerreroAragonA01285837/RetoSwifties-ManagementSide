//
//  TurnosModel.swift
//  RetoSwifties-ManagementSide
//
//  Created by David on 23/09/25.
//

import Foundation
	
struct Turn: Codable, Identifiable, Equatable {
    let preferentialTurn: Bool
    let served: Bool
    let serviceID: Int
    let turnDate: String
    let turnNumber: Int
    var id: Int { serviceID }
}
