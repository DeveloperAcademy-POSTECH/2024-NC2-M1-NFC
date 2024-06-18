//
//  PCBooking.swift
//  Pikacho
//
//  Created by Hajin on 6/18/24.
//

import Foundation

class PCBooking: Identifiable {
    var id: UUID
    var name: String
    var perposeOfReservation: String?
    var numberOfPeople: Int?
    var password: Int
//    var hoursOfUse:
    var colorOfRow: PCColorList = .default

    init(id: UUID, name: String, perposeOfReservation: String? = nil, numberOfPeople: Int? = nil, password: Int, colorOfRow: PCColorList) {
        self.id = id
        self.name = name
        self.perposeOfReservation = perposeOfReservation
        self.numberOfPeople = numberOfPeople
        self.password = password
        self.colorOfRow = colorOfRow
    }
}
