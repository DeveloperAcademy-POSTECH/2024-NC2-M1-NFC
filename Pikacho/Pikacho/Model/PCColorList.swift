//
//  PCColorList.swift
//  Pikacho
//
//  Created by Hajin on 6/18/24.
//

import Foundation
import SwiftUI


enum PCColorList: Int, CaseIterable, Hashable, Codable {
    case `default`
    case timeTable1
    case timeTable2
    case timeTable3
    case timeTable4
    case timeTable5
    case timeTable6
    case timeTable7
    case timeTable8
    case timeTable9
    case timeTable10
    case timeTable11
    case timeTable12
    case timeTable13

    var tabkeBackgroundColor: Color {
        switch self {
        case .default:
            return Color(hex: 0xECECEC)
        case .timeTable1:
            return Color(hex: 0xF9E398)
        case .timeTable2:
            return Color(hex: 0xFBE5CE)
        case .timeTable3:
            return Color(hex: 0xFFCFD2)
        case .timeTable4:
            return Color(hex: 0xF2C0E6)
        case .timeTable5:
            return Color(hex: 0xCFB9F1)
        case .timeTable6:
            return Color(hex: 0xA4C3F2)
        case .timeTable7:
            return Color(hex: 0x90DAF3)
        case .timeTable8:
            return Color(hex: 0x91EBF4)
        case .timeTable9:
            return Color(hex: 0x99F5E0)
        case .timeTable10:
            return Color(hex: 0xB9FBBE)
        case .timeTable11:
            return Color(hex: 0xD4E6F4)
        case .timeTable12:
            return Color(hex: 0xFAF9CD)
        case .timeTable13:
            return Color(hex: 0xFCD1BE)
        }
    }
}
