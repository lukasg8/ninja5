////
////  VerticalCalendarCellView.swift
////  ninja5
////
////  Created by Lukas on 5/6/23.
////
//
//import SwiftUI
//
//struct VerticalCalendarCellView: View {
//    
//    @EnvironmentObject var manager: DataManager
//    @EnvironmentObject var dateHolder: DateHolder
//    
//    let date: Date
//    let tasks: [Task]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            dayHeader()
//            Divider()
//            ForEach(tasks, id: \.id) { task in
//                Text(task.title)
//            }
//        }
//    }
//    
//    func dayHeader() -> some View {
//        let dayOfWeekText = dayOfWeek()
//        let dayMonthText = dayMonth()
//        let dayNumberText = dayNumber()
//        let dayYearText = dayYear()
//        
//        return Text(dayOfWeekText + " " + dayMonthText + " " + dayNumberText + " " + dayYearText)
//    }
//    
//    func dayOfWeek() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "E"
//        return dateFormatter.string(from: date)
//    }
//    
//    func dayNumber() -> String {
//        let components = Calendar.current.dateComponents([.day], from: date)
//        return String(components.day!)
//    }
//    
//    func dayMonth() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        return dateFormatter.string(from: date)
//    }
//    
//    func dayYear() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YY"
//        return dateFormatter.string(from: date)
//    }
//    
//    func isToday() -> Bool {
//        return Calendar.current.isDateInToday(date)
//    }
//}
//
//
