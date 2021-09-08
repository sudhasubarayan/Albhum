//
//  Albums.swift
//  Albhum
//
//  Created by Sudha on 08/09/21.
//

import Foundation

struct AlbumsListResponse: Identifiable, Codable {
    let userId: Int?
    let id: Int?
    let title: String
}

