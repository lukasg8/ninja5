//
//  DataModels.swift
//  ninja5
//
//  Created by Lukas on 4/26/23.
//

import SwiftUI
import Foundation

// MARK: Productivity Data Models

enum FolderColor: String {
    case blue, red, green, purple

    var hexValue: String {
        switch self {
        case .blue:
            return "#00A4FF"
        case .red:
            return "#FF3C72"
        case .green:
            return "#B0FF97"
        case .purple:
            return"#3A45FF"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct Folder: Identifiable, Codable {
    let id: UUID
    var name: String
    var colorName: String
    var notes: [Note]
    var tasks: [Task]
    var subfolders: [Folder]

    var color: Color {
        return Color(hex: FolderColor(rawValue: colorName)?.hexValue ?? "#FFFFFF")
    }
}

extension Folder: Hashable {
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Folder: Equatable { }



struct Task: Identifiable, Codable {
    let id:UUID
    var title: String
    var date: Date
    var folder: Folder?
}


struct Note: Identifiable, Hashable, Codable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id &&
            lhs.canvasData == rhs.canvasData &&
            lhs.title == rhs.title &&
            lhs.selected == rhs.selected &&
            lhs.folder?.id == rhs.folder?.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID
    var canvasData: Data
    var title: String
    var selected: Bool
    var folder: Folder?
}


// MARK: Calendar Data Models
struct MonthStruct
{
    var monthType: MonthType
    var dayInt : Int
    func day() -> String
    {
        return String(dayInt)
    }
}

enum MonthType
{
    case Previous
    case Current
    case Next
}

struct WeekStruct
{
    var weekType: WeekType
    var dayInt: Int
    func day() -> String
    {
        return String(dayInt)
    }
}

enum WeekType
{
    case Previous
    case Current
    case Next
}

