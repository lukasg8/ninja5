//
//  WeekCalendarCellView.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import SwiftUI

struct WeekCalendarCellView: View {
    @EnvironmentObject var dateHolder: DateHolder
    let date: Date
    let tasks: [Task]
    
    var body: some View {
        
        VStack (alignment:.leading, spacing:0) {
            HStack {
                dayHeader()
//                Spacer()
//                Text(dayOfWeek())
//                    .foregroundColor(.black)
//                ZStack {
//                    currentDayCircle()
//                    Text(dayNumber())
//                        .foregroundColor(textColor())
//                }
//                Spacer()
            }
            .padding(.bottom,3)
            Divider()
            taskList()
            Spacer()
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func dayHeader() -> some View {
        HStack {
            Text(dayOfWeek() + "  " + dayNumber())
                .foregroundColor(.black)
                .padding(.horizontal, 8) // Add some horizontal padding to make the rectangle a bit wider than the text
                .padding(.vertical, 4) // Add some vertical padding to make the rectangle a bit taller than the text
                .background(RoundedRectangle(cornerRadius: 15).fill(Color("LightGray")))
            Spacer()
        }
    }

    func taskList() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                ForEach(tasks) { task in
                    Text(task.title)
                        .padding(.leading)
                        .font(.footnote)
                        .foregroundColor(Color(.label))
                        .lineLimit(1)
                }
            }
        }
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    func textColor() -> Color {
        if isToday() {
            return Color.white
        } else {
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
            let currentDateComponents = Calendar.current.dateComponents([.year, .month], from: dateHolder.date)
            
            return (dateComponents.year == currentDateComponents.year && dateComponents.month == currentDateComponents.month) ? Color.black : Color.gray
        }
    }
    
    func dayNumber() -> String {
        let components = Calendar.current.dateComponents([.day], from: date)
        return String(components.day!)
    }
    
    func currentDayCircle() -> some View {
        return Group {
            Circle()
                .fill(isToday() ? Color.red : Color.clear)
                .frame(width: 26, height: 26)
        }
    }
    
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }

}
